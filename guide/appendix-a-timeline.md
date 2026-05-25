---
title: "付録 A — タイムライン"
last_updated: 2026-05-25
chapter_id: appendix-a-timeline
---

## 付録 A — タイムライン

元講演 (2025/5/22) から本ドキュメント執筆時 (2026/4/17) までの主要イベント:

| 時期 | 出来事 |
|---|---|
| 2025/5/22 | Code w/ Claude カンファレンス。Boris 氏の講演。Sonnet 4 / Opus 4 世代 |
| 2025 夏 | Anthropic 社内で Claude Code 利用率 80% 到達 |
| 2025/10 | Anthropic Release Notes — Sonnet 4.5 発表 |
| 2025/11 | **Plugin システム** パブリックベータ開始 |
| 2025 秋 | Subagent の `.claude/agents/` 形式が一般化 |
| 2026/1 | Sonnet 4.6 発表 (1M context ベータ) |
| 2026/2 | **Remote Control** 登場 (research preview) |
| 2026/2 | **Agent Teams** 実験機能として登場 |
| 2026/2/24 | Cowork エンタープライズ大型アップデート (私設マーケットプレイス、12 MCP コネクタ追加) |
| 2026/3 | **Auto Mode** ローンチ (AI 分類器による承認自動化) |
| 2026/3 | **Scheduled Tasks** ローンチ (cron 実行) |
| 2026/3/13 | Opus 4.6 の 1M context が Max/Team/Enterprise で GA |
| 2026/3/23 | **Computer Use** を Claude Code と Cowork で有効化 (Pro/Max) |
| 2026/3 | Agent SDK Python/TypeScript パッケージ GA |
| 2026/3 | Advisor Tool ベータ |
| 2026/3 | Gemini CLI が Plan Mode をデフォルト化 |
| 2026/4 | Haiku 4.5 登場 |
| 2026/4/1 | Managed Agents パブリックベータ |
| 2026/4/16 | **Opus 4.7** GA。`xhigh` effort level 追加 |
| 2026/4/19 | **ネイティブバイナリ化** (v2.1.113): CLI が JS バンドルからネイティブ実行ファイルへ移行 |
| 2026/4下旬 | **デフォルト effort `high`** (v2.1.117): Pro/Max の Opus 4.6・Sonnet 4.6 で effort デフォルトが high に |
| 2026/4下旬 | **Vim ビジュアルモード** (v2.1.118): `v`/`V` でテキスト・行選択が可能に |
| 2026/4下旬 | **/usage 統合** (v2.1.118): `/cost`・`/stats` を `/usage` に集約 |
| 2026/4下旬 | **Hooks から MCP ツール呼び出し** (v2.1.118): `type: "mcp_tool"` ハンドラ追加 |
| 2026/4下旬 | **カスタムテーマ対応** (v2.1.118): `/theme` から名前付きテーマ作成・切替 |
| 2026/5/1 頃 | **claude ultrareview** (v2.1.120): CI 向け非対話コードレビューサブコマンド |
| 2026/5/1 頃 | **MCP alwaysLoad / plugin prune** (v2.1.121): MCP 常時ロード・孤立依存削除 |
| 2026/5/4 頃 | **claude project purge** (v2.1.126): プロジェクト状態 (履歴・タスク) 一括削除 |
| 2026/5上旬 | **`worktree.baseRef`** (v2.1.133): Worktree 分岐元を `fresh`/`head` で設定可能に |
| 2026/5上旬 | **`autoMode.hard_deny`** (v2.1.136): 無条件ブロックルールが Auto Mode に追加 |
| 2026/5中旬 | **`claude agents` Agent View** (v2.1.139): 全セッション一覧 UI (Research Preview) |
| 2026/5中旬 | **`/goal` コマンド** (v2.1.139): 完了条件を設定し達成まで Claude が自律継続 |
| 2026/5中旬 | **Hook exec form / `continueOnBlock`** (v2.1.139): args[] で直接起動、ブロック後も継続 |
| 2026/5中旬 | **`terminalSequence` hook フィールド** (v2.1.141): ヘッドレスでもデスクトップ通知可 |
| 2026/5中旬 | **プラグイン依存管理強制** (v2.1.143): disable/enable が依存関係を強制 |
| 2026/5下旬 | **`/model` セッション限定** (v2.1.144): `d` でデフォルト変更に変更 |
| 2026/5下旬 | **`/simplify` → `/code-review`** (v2.1.147): 旧 cleanup 動作廃止・バグ検出コマンドに刷新 |

---
