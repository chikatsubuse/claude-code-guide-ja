#!/usr/bin/env bash
# scripts/fetch-changelog-diff.sh
#
# Claude Code の CHANGELOG.md から、state/last-changelog-sha.txt 以降の差分を
# 抽出して /tmp/changelog-diff.md に出力する。
#
# 必要なもの: curl, git (sparse clone 用), python3

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
STATE_SHA_FILE="$REPO_ROOT/state/last-changelog-sha.txt"
STATE_VERSION_FILE="$REPO_ROOT/state/last-changelog-version.txt"
OUT_FILE="/tmp/changelog-diff.md"
TMP_DIR="$(mktemp -d)"
trap "rm -rf $TMP_DIR" EXIT

echo "==> Fetching anthropics/claude-code CHANGELOG.md"

# Shallow clone only CHANGELOG.md via sparse checkout
cd "$TMP_DIR"
git init -q
git remote add origin https://github.com/anthropics/claude-code.git
git config core.sparseCheckout true
echo "CHANGELOG.md" > .git/info/sparse-checkout
# Fetch recent commits (we need history to compute diff; depth=200 is plenty for 1 week)
git fetch -q --depth=200 origin main
git checkout -q FETCH_HEAD -- CHANGELOG.md

LATEST_SHA=$(git rev-parse FETCH_HEAD)
echo "   Latest main SHA: $LATEST_SHA"

# Determine the previous SHA
if [[ -f "$STATE_SHA_FILE" ]]; then
    # Strip comments (# ...) and blank lines, take first non-empty token
    PREV_SHA=$(grep -v '^[[:space:]]*#' "$STATE_SHA_FILE" | grep -v '^[[:space:]]*$' | head -1 | tr -d '[:space:]')
    if [[ -z "$PREV_SHA" ]]; then
        echo "   (state file empty or only comments — falling back to HEAD~20)"
        PREV_SHA="HEAD~20"
    fi
    echo "   Previous SHA: $PREV_SHA"
else
    # First run: use HEAD~20 as a reasonable starting point
    PREV_SHA="HEAD~20"
    echo "   First run — using: $PREV_SHA as starting point"
fi

# Resolve HEAD~N into an actual commit SHA for stable comparison.
# Important: resolve relative to FETCH_HEAD (the fetched branch tip),
# not the shallow clone's local HEAD which may not exist usefully.
if [[ "$PREV_SHA" =~ ^HEAD~([0-9]+)$ ]]; then
    N="${BASH_REMATCH[1]}"
    RESOLVED_SHA=$(git rev-parse "FETCH_HEAD~$N" 2>/dev/null || echo "")
    if [[ -n "$RESOLVED_SHA" ]]; then
        echo "   Resolved HEAD~$N (relative to FETCH_HEAD) → $RESOLVED_SHA"
        PREV_SHA="$RESOLVED_SHA"
    else
        # Shallow clone didn't have enough depth; fall back to earliest available
        PREV_SHA=$(git rev-list --max-parents=0 FETCH_HEAD 2>/dev/null | head -1 || echo "")
        if [[ -z "$PREV_SHA" ]]; then
            # Last resort: use the oldest commit we have
            PREV_SHA=$(git log --pretty=format:'%H' FETCH_HEAD | tail -1)
        fi
        echo "   HEAD~$N not in shallow clone; falling back to: $PREV_SHA"
    fi
elif [[ "$PREV_SHA" == "HEAD" ]]; then
    PREV_SHA=$(git rev-parse FETCH_HEAD)
fi

# Short-circuit if unchanged
if [[ "$PREV_SHA" == "$LATEST_SHA" ]]; then
    echo "==> No new commits since $PREV_SHA. Writing empty diff."
    cat > "$OUT_FILE" <<EOF
<!--
meta:
  previous_sha: $PREV_SHA
  latest_sha: $LATEST_SHA
  fetched_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
  note: No new commits to CHANGELOG.md since last run.
-->

CHANGELOG に変更なし。
EOF
    exit 0
fi

# Compute the diff: lines added to CHANGELOG.md between PREV_SHA and FETCH_HEAD
echo "==> Computing diff: $PREV_SHA..$LATEST_SHA"

DIFF_RAW=$(git diff "$PREV_SHA..FETCH_HEAD" -- CHANGELOG.md 2>/dev/null || echo "")

if [[ -z "$DIFF_RAW" ]]; then
    echo "   Previous SHA not in history; falling back to full CHANGELOG head"
    DIFF_RAW=$(head -200 CHANGELOG.md)
    CONTEXT_NOTE="Previous SHA not found in history — showing first 200 lines of current CHANGELOG as fallback."
else
    CONTEXT_NOTE="Standard git diff between previous and latest SHA."
fi

# Extract only added lines (starting with + but not +++) and clean prefix
ADDED_LINES=$(echo "$DIFF_RAW" | python3 -c '
import sys
for line in sys.stdin:
    if line.startswith("+++"):
        continue
    if line.startswith("+"):
        print(line[1:], end="")
' )

# Write the output with metadata header
cat > "$OUT_FILE" <<EOF
<!--
meta:
  previous_sha: $PREV_SHA
  latest_sha: $LATEST_SHA
  fetched_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
  note: $CONTEXT_NOTE
-->

EOF

if [[ -z "$ADDED_LINES" ]]; then
    echo "(追加行なし — フォーマット修正等の変更のみ)" >> "$OUT_FILE"
else
    echo "$ADDED_LINES" >> "$OUT_FILE"
fi

# Extract the latest version number for state tracking
LATEST_VERSION=$(echo "$ADDED_LINES" | grep -oE '^## [0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/^## //' || echo "")
if [[ -n "$LATEST_VERSION" ]]; then
    echo "$LATEST_VERSION" > "$TMP_DIR/latest-version.txt"
    echo "   Latest version extracted: $LATEST_VERSION"
fi

# Report
ADDED_COUNT=$(echo "$ADDED_LINES" | grep -c '^## [0-9]' || true)
echo "==> Diff written to: $OUT_FILE"
echo "    Releases detected: $ADDED_COUNT"
echo "    Byte size: $(wc -c < "$OUT_FILE") bytes"

# Emit the latest SHA so Claude Code / the workflow can use it
echo "$LATEST_SHA" > /tmp/latest-changelog-sha.txt
if [[ -f "$TMP_DIR/latest-version.txt" ]]; then
    cp "$TMP_DIR/latest-version.txt" /tmp/latest-changelog-version.txt
fi

echo "==> Done"
