---
title: "0. この 1 年で何が変わったか"
last_updated: 2026-04-17
chapter_id: 01-whats-changed
---

## 0. この 1 年で何が変わったか

2025 年 5 月、Boris Cherny 氏が Code w/ Claude で披露した Claude Code は、**「対話型 CLI + ヘッドレス SDK」** という姿をしていました。
それから約 11 ヶ月が経った 2026 年 4 月現在、Claude Code は別物に進化しています。
一言でまとめると —

> **Claude Code は CLI ツールから、自律エージェント・プラットフォームに変わった。**

### 講演当時の予言と、現在地

Boris 氏は講演で「Claude Code は **Infinitely hackable** である」「**IDE が主要な UI でなくなる可能性** に備えている」と語りました。この 2 つの読みは、驚くほど正確に当たりました。

- **"Infinitely hackable"** → **Skills / Subagents / Agent Teams / Plugins / Hooks / MCP Servers** の 6 種類の拡張機構が揃い、コミュニティには 2,400 件以上の Skills と 2,500 以上のマーケットプレイスが生まれた
- **"IDE が不要になる未来"** → Cowork というデスクトップ版が登場し、GitHub Copilot までもが Claude Opus モデルを搭載。「IDE の中の AI」から「AI が環境を操作する」方向に市場全体がシフト

### 2025 年 5 月 → 2026 年 4 月 の主な変化

| 領域 | 2025 年 5 月時点 | 2026 年 4 月時点 |
|---|---|---|
| **主要モデル** | Claude 4 (Opus / Sonnet) | **Opus 4.7** (2026/4/16 GA, `xhigh` effort level), **Sonnet 4.6** (1M context GA), **Haiku 4.5** |
| **コンテキスト窓** | 200K tokens | 200K 標準 + **1M tokens** (Opus 4.6 以降で GA) |
| **SDK** | CLI (`claude -p`) のみ。TS/Python は「近日公開」 | **Agent SDK に改名**。Python/TS パッケージ GA。Anthropic / Bedrock / Vertex 対応 |
| **承認フロー** | 階層的 allow/deny list | + **Auto Mode** (AI 分類器が危険動作のみブロック) |
| **Sub-agent** | 内蔵ツールの 1 つ | **`.claude/agents/` で自作可能**。Agent Teams で複数インスタンスが直接通信 |
| **スラコマ** | `.claude/commands/*.md` | **Skills に統合**。`.claude/commands/` は互換維持 |
| **配布** | 各自手動コピー | **Plugin Marketplace** (2025/11 〜) で `/plugin install` |
| **画像入力** | ドラッグ&ドロップ | +ネイティブ **Computer Use** (GUI 操作) |
| **実行環境** | ローカル端末で対話 | + **Scheduled Tasks** (cron 実行), + **Remote Control** (スマホ制御), + **Cloud sessions** |
| **音声** | macOS Dictation ハック | **Voice モード**がネイティブ実装 (20 言語対応) |
| **ライフサイクル拡張** | なし | **Hooks** (12 イベント): PreToolUse / PostToolUse / SessionStart / SubagentStop / PreCompact 等 |
| **IDE 統合** | 外部 CLI のまま | **Native VS Code 拡張** |

### 元講演から変わらないもの (骨格)

変化は大きい一方で、Boris 氏が示した **学習曲線の設計** は 2026 年版でもそのまま使えます。

- **"Q&A から始めよ"** → 今でも全ての入門ガイドが最初に書く鉄則
- **CLAUDE.md の中核性** → Skills 等が増えても、プロジェクトの「憲法」は依然 CLAUDE.md
- **"検証手段を与えて反復させよ"** → Superpowers プラグインなどが「brainstorm → design spec → plan → subagent execution → review」として体系化した思想的起源
- **4 段階ロードマップ** (Q&A → 編集 → チーム → スクリプト化) → 本ドキュメントでも維持 (+1 段階追加)

このドキュメントでは、**Boris 氏の 4 段階ロードマップに「拡張機構 (Extending Claude)」を第 3 段階として追加した 5 段階** で進めます。

---
