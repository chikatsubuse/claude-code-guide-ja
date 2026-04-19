#!/usr/bin/env bash
# scripts/build-docs.sh
#
# guide/*.md を MkDocs 用に docs/ へコピーし、
# トップページ docs/index.md を README の要約から生成する。
#
# Claude Code が編集するソースは guide/ のまま、
# 公開用コピーは docs/ に置く分離設計。
#
# YAML フロントマターはそのまま保持 (last_updated をサイト上で活用可能)。

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GUIDE_DIR="$REPO_ROOT/guide"
DOCS_DIR="$REPO_ROOT/docs"

echo "==> Building docs/ from guide/"

# docs/ を再生成 (古いファイルが残らないように)
rm -rf "$DOCS_DIR"
mkdir -p "$DOCS_DIR"

# guide/*.md をコピー (00-front-matter.md は index.md で代替するのでスキップ)
for f in "$GUIDE_DIR"/*.md; do
  name=$(basename "$f")
  if [[ "$name" == "00-front-matter.md" ]]; then
    echo "    - $name (skipped — replaced by index.md)"
    continue
  fi
  cp "$f" "$DOCS_DIR/$name"
  echo "    + $name"
done

# トップページを生成
cat > "$DOCS_DIR/index.md" <<'EOF'
---
title: "概要"
hide:
  - navigation
---

# Claude Code 入門ガイド (日本語)

Anthropic の **Claude Code** について、**毎週自動で最新情報にアップデートされる** 日本語入門ガイドです。

!!! info "このガイドについて"
    2025 年 5 月の Anthropic 社カンファレンス「Code w/ Claude」における
    Boris Cherny 氏の講演 **"Mastering Claude Code in 30 minutes"** を出発点に、
    そこから約 1 年の進化を全面反映した改訂版。
    元講演の 5 段階ロードマップという骨格をそのまま活かし、
    各段階の中身を最新仕様に継続アップデートしている。

!!! tip "自己更新システム"
    このサイトは **Claude Code 自身が毎週自分の CHANGELOG と公式ブログを読み、
    ガイドに反映させる** 自己更新システムで運用されている。
    GitHub 上のリポジトリは [chikatsubuse/claude-code-guide-ja](https://github.com/chikatsubuse/claude-code-guide-ja)。

## 読み方

**はじめての方** は `0. この1年で変わったこと` → `1. インストール` → `2. コードベース Q&A` の順に。

**特定の機能を調べたい方** は、画面右上の検索 🔍 を活用。

**全体を通読したい方** は、サイドバーの順序通りに読む。

## 5 段階ロードマップ

このガイドは Boris 氏の講演の 5 段階モデルで構成されている:

| 段階 | テーマ | 章 |
|---|---|---|
| 第1段階 | **Getting your feet wet** | インストール → Q&A |
| 第2段階 | **You are no longer a padawan** | 編集・ツール → Auto Mode |
| 第3段階 | **Extending Claude** (新設) | 拡張機構 → Plugin |
| 第4段階 | **Scaling up** | チームで使う |
| 第5段階 | **Leveling up** | Agent SDK → 並列実行 |

## 最新の週次サマリ

各週の更新記録は [GitHub 上の `state/weekly-summaries/`](https://github.com/chikatsubuse/claude-code-guide-ja/tree/master/state/weekly-summaries) で確認できる。

## ライセンス

- ガイド本文: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ja)
- スクリプト・ワークフロー: MIT
EOF

echo "    + index.md (generated)"

COUNT=$(ls -1 "$DOCS_DIR"/*.md | wc -l | tr -d ' ')
echo "==> docs/ ready ($COUNT files)"
