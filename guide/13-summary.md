---
title: "12. まとめ: 2026 年版 5 段階ロードマップ"
last_updated: 2026-04-17
chapter_id: 13-summary
---

## 12. まとめ: 2026 年版 5 段階ロードマップ

Boris 氏の 4 段階に、2026 年に必須となった **"Extending Claude"** を第 3 段階として追加した 5 段階モデルです。

```
  第1段階: Getting your feet wet        →  コードベース Q&A
                     ↓
  第2段階: You are no longer a padawan  →  編集 + ツール + Auto Mode
                     ↓
  第3段階: Extending Claude (新設)      →  Skills / Subagents / Plugins / Hooks
                     ↓
  第4段階: Scaling up                    →  チームで共有 (CLAUDE.md + 拡張機構)
                     ↓
  第5段階: Leveling up                   →  Agent SDK / 並列実行 / スケジュール
```

### 各段階での到達目標

**第1段階: Q&A** (1〜2 日)
- コードベースに質問を投げる習慣
- `@` メンションでファイルを指定
- `think hard` で深い分析を引き出す
- 「Claude にできること / まだできないこと」の感覚を得る

**第2段階: 編集 + ツール** (1〜2 週間)
- ファイル編集を承認しながら運用
- プロジェクト固有の Bash コマンドを教える
- MCP サーバーを 1〜2 個つなぐ (GitHub, Playwright など)
- Auto Mode を試して承認地獄から脱出
- **フィードバックループ**を構築 (テスト / Lint / スクショ)

**第3段階: 拡張** (1 ヶ月〜)
- `.claude/skills/` に自分のワークフローを Skill 化
- よく使うタスクを Subagent に切り出し (`.claude/agents/`)
- PostToolUse hook で自動テストを仕込む
- 人気プラグインをインストールして慣れる (Superpowers など)

**第4段階: チーム展開** (継続的)
- **Tip #7 (2026 年版)**: CLAUDE.md + `.claude/commands` + `.claude/skills` + `.claude/agents` + `.mcp.json` + `.claude/settings.json` を Git にコミット
- Enterprise policy で組織全体ルールを配布
- プライベート Plugin Marketplace で社内拡張を共有

**第5段階: 自律化** (応用)
- Agent SDK で CI/CD や内部ツールに組み込み
- Scheduled Tasks で定期的な自律実行
- Remote Control でスマホから監視
- Agent Teams で真の並列作業 (実験的)

### 「Boris 氏の Tip 8 か条」2026 年版

| # | 元 Tip | 2026 年での拡張 |
|---|---|---|
| 1 | Codebase Q&A から始める | **変わらず**。これは普遍 |
| 2 | 組み込みツールを使う | + Skill ツール / Computer Use / Schedule |
| 3 | チームのツールを教える | + MCP マーケットプレイス / Tool Search |
| 4 | タスクに合わせたワークフロー | + Plan Mode / Rewind / Auto Mode |
| 5 | コンテキストを与える | + Skills / Nested CLAUDE.md |
| 6 | スコープを使い分ける | + Skills / Subagents / Hooks もスコープあり |
| 7 | **チーム設定を Git にコミット** | + Plugin Marketplace / `.claude/agents/` も対象 |
| 8 | SDK で自動化 | + **Agent SDK** (Python/TS GA) + Managed Agents + Advisor |

---
