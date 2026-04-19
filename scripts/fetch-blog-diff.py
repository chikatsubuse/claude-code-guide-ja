#!/usr/bin/env python3
"""
scripts/fetch-blog-diff.py

claude.com/ja-jp/blog の新着記事を検出し、state/last-blog-urls.json に未記録の
記事を /tmp/new-blog-posts.json に書き出す。
"""
from __future__ import annotations

import json
import re
import sys
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
STATE_FILE = REPO_ROOT / "state" / "last-blog-urls.json"
OUT_FILE = Path("/tmp/new-blog-posts.json")
BLOG_URL = "https://claude.com/ja-jp/blog"
USER_AGENT = "ClaudeCodeGuideWeeklyUpdater/1.0"

# Regex to find blog post links within the listing HTML.
# The site is a Webflow CMS; links follow /ja-jp/blog/<slug> format.
LINK_PATTERN = re.compile(
    r'href="(/ja-jp/blog/[a-z0-9\-]+)"[^>]*?>([^<]+)</a>',
    re.IGNORECASE,
)
# Date patterns commonly appear near each post (e.g., "April 15, 2026" / "Dec 9, 2025")
DATE_PATTERN = re.compile(
    r'(January|February|March|April|May|June|July|August|September|October|November|December|'
    r'Jan|Feb|Mar|Apr|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2},?\s+\d{4}'
)


def fetch_html(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as resp:
        raw = resp.read()
    # Try utf-8 first, fall back
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError:
        return raw.decode("utf-8", errors="replace")


def load_state() -> dict:
    if STATE_FILE.exists():
        return json.loads(STATE_FILE.read_text())
    return {"known_urls": [], "last_checked": None}


def extract_posts(html: str) -> list[dict]:
    """Extract unique blog post entries from the listing HTML."""
    seen_paths = set()
    posts = []
    # Extract candidate links
    for match in LINK_PATTERN.finditer(html):
        path, title = match.groups()
        # Skip category pages like /ja-jp/blog/category/xxx
        if "/category/" in path:
            continue
        if path in seen_paths:
            continue
        seen_paths.add(path)
        title = title.strip()
        if not title:
            continue
        # Skip obvious non-post titles
        if len(title) < 8 or "詳細を読む" in title:
            # Find the corresponding title by looking at HTML chunks near this link
            continue
        posts.append({
            "url": f"https://claude.com{path}",
            "title": title,
            "date": None,           # Filled below if detectable
            "category": None,       # Filled below if detectable
        })
    # Try to associate dates from the surrounding HTML (best effort)
    # Scan the full HTML in order of appearance, pairing dates with the closest prior title
    # We simply attach *first found date* near each URL-bearing snippet.
    for post in posts:
        # Locate the first occurrence of the URL path in the HTML
        path = post["url"].replace("https://claude.com", "")
        idx = html.find(path)
        if idx < 0:
            continue
        # Search ±500 chars around this index for a date
        window = html[max(0, idx - 500):idx + 500]
        m = DATE_PATTERN.search(window)
        if m:
            post["date"] = m.group(0)
    return posts


def parse_date(s: str | None) -> datetime | None:
    if not s:
        return None
    for fmt in ("%B %d, %Y", "%b %d, %Y", "%B %d,%Y", "%b %d,%Y"):
        try:
            return datetime.strptime(s.replace(",", ", ").replace(",  ", ", "), fmt)
        except ValueError:
            continue
    return None


def main() -> int:
    print(f"==> Fetching blog list: {BLOG_URL}")
    try:
        html = fetch_html(BLOG_URL)
    except Exception as exc:
        print(f"   Failed to fetch blog list: {exc}", file=sys.stderr)
        # Write an empty result with the SAME schema as success so downstream
        # steps (GitHub Actions, Claude Code skill) don't break on missing keys.
        OUT_FILE.write_text(json.dumps({
            "fetched_at": datetime.now(timezone.utc).isoformat(),
            "blog_url": BLOG_URL,
            "new_posts": [],
            "all_posts_count": 0,
            "known_posts_count": len(load_state().get("known_urls", [])),
            "error": str(exc),
        }, ensure_ascii=False, indent=2))
        return 0

    print(f"   HTML size: {len(html):,} bytes")
    posts = extract_posts(html)
    print(f"   Candidate posts found: {len(posts)}")

    state = load_state()
    known = set(state.get("known_urls", []))
    new_posts = [p for p in posts if p["url"] not in known]

    # Sort newest first when dates are available
    new_posts.sort(key=lambda p: parse_date(p["date"]) or datetime.min, reverse=True)

    # Write output
    out = {
        "fetched_at": datetime.now(timezone.utc).isoformat(),
        "blog_url": BLOG_URL,
        "new_posts": new_posts,
        "all_posts_count": len(posts),
        "known_posts_count": len(known),
    }
    OUT_FILE.write_text(json.dumps(out, ensure_ascii=False, indent=2))
    print(f"==> Wrote {len(new_posts)} new posts to: {OUT_FILE}")
    for p in new_posts[:10]:
        print(f"   - [{p.get('date', 'no date')}] {p['title']}")
    if len(new_posts) > 10:
        print(f"   ... and {len(new_posts) - 10} more")
    return 0


if __name__ == "__main__":
    sys.exit(main())
