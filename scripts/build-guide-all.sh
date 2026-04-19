#!/usr/bin/env bash
# scripts/build-guide-all.sh
#
# 各章ファイルを連結して guide-all.md を生成する。
# YAML フロントマターは除去し、章見出しの前に --- を挿入。
# README などに貼れる単一ファイル版を提供する目的。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GUIDE_DIR="$REPO_ROOT/guide"
OUT_FILE="$REPO_ROOT/guide-all.md"

echo "==> Building guide-all.md from guide/*.md"

{
  # Header
  echo "# Claude Code 入門ガイド (統合版)"
  echo
  echo "> このファイルは \`guide/*.md\` を連結した自動生成版。"
  echo "> 生成日時: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "> 章ごとに読みたい場合は [\`guide/\`](./guide/) を参照。"
  echo
  echo "---"
  echo

  # Concatenate each chapter in order
  for f in "$GUIDE_DIR"/*.md; do
    echo "    + $(basename "$f")" >&2
    # Remove YAML frontmatter (first --- block) using awk
    awk '
      BEGIN { in_fm = 0; fm_done = 0 }
      /^---$/ {
        if (!fm_done && !in_fm) { in_fm = 1; next }
        if (in_fm) { in_fm = 0; fm_done = 1; next }
      }
      !in_fm { print }
    ' "$f"
    echo
    echo "---"
    echo
  done
} > "$OUT_FILE"

LINES=$(wc -l < "$OUT_FILE")
BYTES=$(wc -c < "$OUT_FILE")
echo "==> Wrote $OUT_FILE ($LINES lines, $BYTES bytes)"
