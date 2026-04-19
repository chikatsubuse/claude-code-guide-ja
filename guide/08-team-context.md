---
title: "7. チームで使う: コンテキスト共有の完全ガイド"
last_updated: 2026-04-17
chapter_id: 08-team-context
---

## 7. チームで使う: コンテキスト共有の完全ガイド

Boris 氏の Tip #6 と #7 は「CLAUDE.md をチームで共有しコミットせよ」でした。2026 年ではこれが拡張されて、**Skills / Subagents / Hooks / MCP / Plugin** もすべて同じ思想で共有します。

### 7.1 設定スコープの完全マトリックス (2026 年拡張版)

| 種類 | Enterprise (強制) | Global (自分) | Project (共有) | Project (自分) |
|---|---|---|---|---|
| **CLAUDE.md** | `<enterprise>/CLAUDE.md` | `~/.claude/CLAUDE.md` | `CLAUDE.md` | `CLAUDE.local.md` |
| **Skills** | `<enterprise>/.claude/skills/` | `~/.claude/skills/` | `.claude/skills/` | — |
| **Subagents** | `<enterprise>/.claude/agents/` | `~/.claude/agents/` | `.claude/agents/` | — |
| **Slash commands** (旧) | — | `~/.claude/commands/` | `.claude/commands/` | — |
| **Permissions** | `policies.json` | `~/.claude/settings.json` | `.claude/settings.json` | `.claude/settings.local.json` |
| **MCP servers** | `policies.json` | `claude mcp` | `.mcp.json` | `claude mcp --scope project` |
| **Hooks** | `<enterprise>/.claude/hooks/` | `~/.claude/hooks/` | `.claude/hooks/` | — |
| **Plugins** | 管理者配布 | `/plugin install` | `plugin install --scope project` | — |

**判定ルール**:
- 同名なら高位スコープが勝つ (enterprise > project shared > project local > user global)
- Plugin 由来は `plugin-name:skill-name` のように名前空間化され衝突しない

### 7.2 Git にコミットする推奨セット (2026 年版 Tip #7)

**Boris 氏の Tip #7 は 2026 年でも最強のアドバイスです**。ただし対象が増えました。

プロジェクトの `.gitignore` に入れずにコミットすべきファイル:

```
CLAUDE.md                   ← プロジェクト憲法
.claude/
  ├── commands/             ← 旧スラッシュコマンド
  ├── skills/               ← 新・タスク手順書
  ├── agents/               ← カスタムサブエージェント
  ├── hooks/                ← ライフサイクルフック
  └── settings.json         ← 権限・MCP 参照
.mcp.json                   ← MCP サーバー定義
```

**コミットしないもの**:
```
.claude/settings.local.json   ← 個人の権限オーバーライド
CLAUDE.local.md               ← 個人用メモ
```

### 7.3 CLAUDE.md は何を書くか — 2026 年版

**基本**は 2025 年と同じ:
- よく使う Bash コマンド (ビルド / テスト / Lint)
- 重要な設計判断
- コーディングスタイル

**2026 年で追加で書くと強力**:
- **利用可能な Skills のマップ** (「この作業は `/deep-review` を使え」など)
- **利用可能な Subagents** (「DB 操作は `db-reader` agent を使え」)
- **Hooks で走る自動処理の一覧** (Claude が「なぜテストが勝手に走るのか」を理解する)
- **使用推奨 MCP サーバー** (GitHub MCP, Playwright MCP など)
- **ブランチ命名規約** (Claude が PR を作るとき従わせる)

**重要原則 (2025 年のまま)**: **短く保つ**。長いとコンテキスト窓を圧迫して逆効果。300〜500 行を超えたら分割を検討。

### 7.4 `@` メンションと Skills での分割投入

大規模な CLAUDE.md を防ぐには、詳細をネストされた CLAUDE.md や Skills に追い出すのが有効です。

```
project-root/
├── CLAUDE.md                   ← 500 行以内、全体憲法
├── .claude/skills/
│   ├── api-design/SKILL.md     ← API 作業時だけ読まれる
│   └── db-migration/SKILL.md   ← DB 作業時だけ読まれる
└── src/
    ├── api/
    │   └── CLAUDE.md           ← api/ 作業時だけ自動ロード
    └── db/
        └── CLAUDE.md           ← db/ 作業時だけ自動ロード
```

**オンデマンド投入**:
- `@path/to/file.py` — ファイル注入
- `@src/api/` — ディレクトリ注入
- `/api-design` — Skill 明示呼び出し

### 7.5 `/memory` と `#` ショートカット

```bash
/memory
```

現在セッションで読まれているメモリファイルを一覧・編集できます (Enterprise / Global / Project / Nested)。

```
# Always use pnpm, not npm or yarn
```

`#` で始めたメッセージは、適切な CLAUDE.md に**自動追記**されます。講演時から変わらない便利機能で、チーム共有 / 個人メモのどちらに追加するかを対話的に選べます。

### 7.6 Permissions の階層化 (2026 年版)

エンタープライズでは `policies.json` でユーザーが上書きできない強制ルールを配布できます。

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test)",
      "Bash(npm run lint)"
    ],
    "deny": [
      "Bash(curl http://internal-prod.*)",
      "WebFetch(https://internal-docs.example.com/*)"
    ]
  }
}
```

これに加えて 2026 年は:
- `/less-permission-prompts` Skill: 過去の承認履歴から「よく通しているコマンド」を分析し、allow list 候補を提案
- **Auto Mode** を併用すると、明示的ルール + AI 分類器の二重防御になる

---
