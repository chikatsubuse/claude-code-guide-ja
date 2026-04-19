# Claude Code 入門ガイド (日本語・週次更新版)

Anthropic の Claude Code について、**毎週自動で最新情報にアップデートされる** 日本語入門ガイドです。

> 🤖 このリポジトリは、Claude Code 自身が毎週自分の CHANGELOG と公式ブログを読み、ガイドに反映させる自己更新システムで運用されています。

## 📖 ガイドを読む

- **🌐 Web で読む** (推奨): https://chikatsubuse.github.io/claude-code-guide-ja/
    - サイドバーに章一覧、全文検索、ダークモード対応
- 章別 (GitHub): [`guide/`](./guide/) ディレクトリの各 Markdown
- 最終更新の記録: [`state/weekly-summaries/`](./state/weekly-summaries/) に週ごとのサマリ

## 🏗 リポジトリ構成

```
.
├── guide/                     ← 入門ガイド本体 (章ごとに分割)
│   ├── 00-front-matter.md
│   ├── 01-whats-changed.md    ← "この1年で何が変わったか"
│   ├── 02-setup.md            ← インストール・モデル・セットアップ
│   ├── 03-codebase-qa.md      ← コードベース Q&A
│   ├── 04-editing-tools.md    ← 編集・ツール・ワークフロー
│   ├── 05-auto-mode-computer-use.md
│   ├── 06-extension-mechanisms.md   ← Skills/Subagents/Plugins/Hooks/MCP
│   ├── 07-plugin-marketplace.md
│   ├── 08-team-context.md
│   ├── 09-agent-sdk.md
│   ├── 10-parallel-execution.md
│   ├── 11-keybindings-cheatsheet.md
│   ├── 12-competitors.md
│   ├── 13-summary.md
│   ├── 99-closing.md
│   ├── appendix-a-timeline.md
│   └── appendix-b-commands.md
│
├── state/                     ← 更新処理の状態
│   ├── last-changelog-sha.txt       ← 前回処理した CHANGELOG コミット
│   ├── last-changelog-version.txt   ← 前回の最新バージョン番号
│   ├── last-blog-urls.json          ← 既読ブログ URL 一覧
│   └── weekly-summaries/
│       ├── 2026-W16.md              ← 今週のサマリ
│       └── 2026-W17.md              ← 来週のサマリ
│
├── .claude/                   ← Claude Code の設定・Skills
│   ├── CLAUDE.md              ← リポジトリ固有の編集ルール
│   ├── settings.json
│   └── skills/
│       ├── weekly-update/           ← 週次更新のメインフロー
│       ├── reflect-changelog/       ← CHANGELOG を反映するサブ処理
│       └── reflect-blog/            ← ブログを反映するサブ処理
│
├── .github/workflows/
│   └── weekly-update.yml      ← 毎週月曜 9時 JST に実行
│
└── scripts/                   ← 更新処理を支えるシェル/Python
    ├── fetch-changelog-diff.sh
    ├── fetch-blog-diff.py
    └── build-guide-all.sh
```

## ⚙️ 仕組み

### 週次ジョブの流れ

```
毎週月曜 00:00 UTC (09:00 JST)
    ↓
GitHub Actions がトリガー
    ↓
scripts/fetch-changelog-diff.sh
    ├─ CHANGELOG.md を取得
    └─ state/last-changelog-sha.txt 以降の差分を /tmp/changelog-diff.md に抽出
    ↓
scripts/fetch-blog-diff.py
    ├─ https://claude.com/ja-jp/blog を取得
    └─ state/last-blog-urls.json に無い新着を /tmp/new-blog-posts.json に抽出
    ↓
claude -p --bare "@.claude/skills/weekly-update/SKILL.md"
    ├─ 差分を読んで重要度を判定
    ├─ state/weekly-summaries/YYYY-Www.md に今週サマリを作成
    ├─ 必要に応じて guide/NN-*.md の該当章に追記
    ├─ guide/appendix-a-timeline.md に 1 行追加
    ├─ 破壊的変更があれば README の "⚠️ 重要な変更" セクションを更新
    └─ state/ の SHA と URL 一覧を更新
    ↓
PR を作成 (自動マージはしない)
    ↓
人間が 15 分以内でレビュー → Merge
```

### なぜ PR 経由にするか

**意図的に完全自動マージはしていません**。

1. **誤情報混入のリスク**: LLM が CHANGELOG の意味を誤解しうる
2. **文体の一貫性**: 既存の章構成を尊重した反映には人間の判断が必要
3. **重大な発表の扱い**: 章の新設 / 既存章への追記 / 削除などは人間が決める

PR レビューは **週 1 回 15 分以内** に収まる想定です。

## 🚀 初期セットアップ

### 1. リポジトリを GitHub に push

このディレクトリをそのまま GitHub にコミット・push します。

### 2. Secrets に API キーを登録

GitHub リポジトリの Settings → Secrets and variables → Actions で以下を登録:

- `ANTHROPIC_API_KEY` — Claude API キー (Pro/Max プランか従量課金)

### 3. 初回実行

```bash
# ローカルで動作確認するなら:
export ANTHROPIC_API_KEY=sk-...
bash scripts/fetch-changelog-diff.sh
python3 scripts/fetch-blog-diff.py
claude -p --bare --allowedTools "Read,Edit,Write,Bash" \
  --permission-mode acceptEdits \
  "Run the weekly-update skill"
```

GitHub Actions 上で手動トリガーするなら:

```
Actions タブ → "Weekly Guide Update" → "Run workflow"
```

### 4. 以降は完全自動

毎週月曜朝に Actions が走り、PR が自動生成されます。通知が来たらレビューしてマージするだけ。

## 💰 運用コスト

| 項目 | 頻度 | 想定コスト |
|---|---|---|
| Claude API (Sonnet 4.6) | 週 1 回 | 約 **$0.30/週** = 月 $1.2 |
| GitHub Actions | 週 1 回 × 約 5 分 | **無料枠内** (public repo は無制限) |
| 人間レビュー | 週 1 回 | **15 分** |

月額合計: **1 〜 2 USD + 人間 1 時間**

## 🙏 元ネタ

- Boris Cherny "Mastering Claude Code in 30 minutes" (Code w/ Claude, 2025/5/22)
- [Claude Code 公式ドキュメント (日本語)](https://code.claude.com/docs/ja/overview)
- [Claude Code CHANGELOG](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)
- [Claude 公式ブログ (日本語)](https://claude.com/ja-jp/blog)

## 📝 ライセンス

ガイド本文: CC BY 4.0
スクリプト・ワークフロー: MIT
