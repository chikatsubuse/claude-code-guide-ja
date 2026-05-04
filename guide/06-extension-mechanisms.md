---
title: "5. 拡張機構の全体像: Skills / Subagents / Agent Teams / Plugins / Hooks / MCP"
last_updated: 2026-05-04
chapter_id: 06-extension-mechanisms
---

## 5. 拡張機構の全体像: Skills / Subagents / Agent Teams / Plugins / Hooks / MCP

**この章は 2026 年版の核心部** です。講演時は「組み込みツール + MCP」で十分だった拡張の世界が、今や **6 層の機構** に発展しました。多くの開発者が「機能が多すぎて何から使えばいいか分からない」と感じているのは、この急速な拡張によるものです。

### 5.1 全体図 — 何が何のためにあるのか

```
┌──────────────────────────────────────────────────────────┐
│                     Claude Code                          │
├──────────────────────────────────────────────────────────┤
│  【知識層】   何を Claude が知っているか                 │
│    ├─ CLAUDE.md       プロジェクト憲法 (常時 in-context) │
│    └─ Skills          タスク別の手順書 (必要時にロード)  │
├──────────────────────────────────────────────────────────┤
│  【実行層】   誰が何をするか                             │
│    ├─ Subagents       隔離コンテキストの作業員          │
│    └─ Agent Teams     複数 Claude が直接協調 (実験)     │
├──────────────────────────────────────────────────────────┤
│  【接続層】   外部とつなぐ                               │
│    └─ MCP Servers     外部ツール/データへの配管         │
├──────────────────────────────────────────────────────────┤
│  【制御層】   自動化の引き金                             │
│    └─ Hooks           12 のライフサイクル イベント      │
├──────────────────────────────────────────────────────────┤
│  【配布層】   パッケージング                             │
│    └─ Plugins         上記を束ねて配布可能に            │
└──────────────────────────────────────────────────────────┘
```

**覚え方**:
- **CLAUDE.md / Skills** = 知識 (「同じ指示を繰り返すのが嫌」になったら)
- **Subagents / Agent Teams** = 作業員 (コンテキストを分離したい / 並列実行したい)
- **MCP Servers** = 手足 (外部ツールへの接続)
- **Hooks** = 自動化 (イベント駆動で処理を挟む)
- **Plugins** = パッケージ (上記を束ねて共有)

### 5.2 Skills — 講演時の「スラコマ」の上位概念

Boris 氏が紹介した `.claude/commands/*.md` (スラッシュコマンド) は、**2026 年に Skills というより強力な概念に統合** されました。

**Skills とは**: ディレクトリ単位のタスク手順書。`SKILL.md` にフロントマター付き指示を書き、補助ファイル (テンプレート、スクリプト、サンプル) を同梱できます。

**構造**:

```
.claude/skills/
└── deep-review/
    ├── SKILL.md              ← フロントマター + 指示本文
    ├── templates/
    │   └── review-format.md
    └── scripts/
        └── collect-diff.sh
```

**SKILL.md のフロントマター例**:

```markdown
---
name: deep-review
description: Perform deep code review with security, performance, and UX checks.
context: fork                  ← サブエージェントで実行
agent: Explore                 ← 読み取り専用エージェント
allowed-tools: Read, Grep, Glob
---

Review $ARGUMENTS thoroughly:
1. Check for security vulnerabilities
2. Flag performance concerns
3. Review test coverage
...
```

**旧 .claude/commands/ との関係**:
- 既存の `.claude/commands/*.md` はそのまま動作
- 同名で Skill が存在する場合、**Skill が優先**
- 新規は `.claude/skills/<name>/SKILL.md` を推奨

**優先度**: `enterprise > personal > project` (同名のとき上位が勝つ)。**プラグイン由来の Skill** は `plugin-name:skill-name` の名前空間を持つので衝突しません。

#### Anthropic 公式の組み込み Skills

Claude Code には次の Skill が標準で同梱されています。

- `/simplify` — コードの簡素化
- `/batch` — バッチ処理生成
- `/debug` — 構造化デバッグ
- `/loop` — 反復実行
- `/claude-api` — Anthropic SDK を使ったアプリ構築

**自動起動**: フロントマターの `description` が会話文脈にマッチすると、Claude が自律的に Skill を発動します。手動呼び出しは `/<name>` または `@skill-name`。

v2.1.120 から、Skill 本文内で `${CLAUDE_EFFORT}` プレースホルダを使うと現在の effort レベルを参照できる。高 effort 時に追加の検証ステップを挿入するといった条件付き動作を Skill 内で記述できる。`/skills` ダイアログ (v2.1.121 〜) にはキーワード検索ボックスが追加され、登録 Skill が多い場合でも素早く絞り込める。

### 5.3 Subagents — 「内蔵ツール」から「自作できる作業員」へ

講演時の sub-agent は内蔵ツールの一つでしたが、**2026 年は誰でも `.claude/agents/` に自作できます**。

#### Subagent の利点

- **独立した 200K トークンコンテキスト** を持つ → 親セッションのコンテキストを汚さない
- **専用のシステムプロンプト** → 役割を明確に
- **ツール権限を絞れる** → 読み取り専用の研究エージェント、書き込み可の実装エージェント、など
- **モデルを分けられる** → 研究は Haiku、実装は Opus などコスト最適化

#### 書き方

```markdown
---
name: security-reviewer
description: Reviews code for security vulnerabilities. Use proactively before commits touching auth, payments, or user data.
tools: Read, Grep, Glob
model: sonnet
---

You are a security-focused code reviewer. Analyze changes for:
- SQL injection, XSS, command injection risks
- Authentication and authorization gaps
- Sensitive data in logs, errors, or responses
- Insecure dependencies

Return a prioritized list of findings with file:line references.
```

保存場所:
- プロジェクト共有: `.claude/agents/security-reviewer.md`
- 個人用: `~/.claude/agents/security-reviewer.md`
- 組織配布: `Managed settings directory/.claude/agents/` (エンタープライズ)

#### 内蔵 Subagent (講演時から順当に拡張)

- **general-purpose** — 何でも屋 (デフォルト)
- **Plan** — コードベース調査 → 実装戦略を計画
- **Explore** — 高速な読み取り専用コード検索

#### 作成は `/agents` コマンドで

手書きもできますが、公式推奨は対話的コマンドです:

```bash
/agents
```

Description を書くと Claude が最初のドラフトを生成してくれます。

#### 実務パターン

PubNub チームが公開している信頼性の高いパイプライン例:

```
pm-spec         → 要件を仕様書にまとめる (READY_FOR_ARCH)
architect-review → 設計を技術制約に照らして検証 (READY_FOR_IMPL)
implementer-tester → 実装 + テスト + UI 確認
release         → リリースノート + デプロイ
```

各 Subagent は `.claude/agents/` にコミットされ、Hooks (次節) で「Subagent A が完了したら B を呼ぶ」というチェーンが自動化されます。

#### 注意: Subagents は無料ではない

**Anthropic 公式によれば、マルチエージェントワークフローは単一エージェントの 4〜7 倍のトークンを消費**。Agent Teams (複数セッション版) は約 15 倍。ただし 2026 年現在はプロンプトキャッシュ読み取りが $0.50/MTok (Opus) と安いので、体感コストはそれほど爆発的ではありません。Pro プランで 5 並列を探索ブン回すと 20 分でレート制限にぶつかるので注意。

### 5.4 Hooks — 12 のライフサイクルイベント

**2026 年初頭に登場した新機構**。Claude Code のエージェントループの「ここ」「そこ」で任意のシェルコマンド/HTTP エンドポイント/LLM プロンプトを実行できます。

#### 12 のイベント

| イベント | 発火タイミング | 代表的用途 |
|---|---|---|
| `SessionStart` | セッション開始・再開時 | 環境変数ロード、最新 Git 状態の投入 |
| `SessionEnd` | セッション終了時 | ログ記録、一時ファイル削除 |
| `UserPromptSubmit` | ユーザ送信直前 | プロンプト検証、強化 |
| `PreToolUse` | ツール実行直前 | **ブロック可能**。危険コマンドの拒否 |
| `PostToolUse` | ツール実行直後 | テスト自動実行、フォーマット、ログ |
| `PreCompact` | コンテキスト圧縮前 | 履歴バックアップ |
| `Notification` | 通知送信時 | TTS アラート |
| `Stop` | Claude の応答完了時 | 完了音、次タスク提示 |
| `SubagentStart` | サブエージェント起動時 | 観測、ログ |
| `SubagentStop` | サブエージェント完了時 | 結果検証、次の Subagent 起動 |
| `PreApproval` | 承認ダイアログ表示時 | 読み取り専用は自動許可 |
| `ToolError` | ツール実行失敗時 | 構造化エラーログ |

#### 最もインパクトが大きい使い方: PostToolUse で自動テスト

```json
// ~/.claude/settings.json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{
        "type": "command",
        "command": "cd $CWD && bun test --bail 2>&1 | tail -10"
      }]
    }]
  }
}
```

Claude がファイルを編集するたびにテストが走り、出力が次のターンのコンテキストに戻る。「壊した → 直す」のループが人間なしで回り始めます。

#### Hook ハンドラの 4 種類

- **Command hook** (`type: "command"`): シェルコマンド実行。JSON を stdin で受け、終了コードで結果を返す
- **Prompt hook** (`type: "prompt"`): Claude モデルに単発評価させる。`$ARGUMENTS` プレースホルダ
- **Agent hook** (`type: "agent"`): サブエージェントを起動して検証 (Read/Grep/Glob アクセス可)
- **MCP Tool hook** (`type: "mcp_tool"`): MCP ツールを直接呼び出す (v2.1.118 〜)

この四種類により、「軽量チェック」「セマンティック評価」「深い分析」「MCP ツール連携」を使い分けられる。

#### PreToolUse で危険コマンドを完全ブロック

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "./scripts/validate-command.sh"
      }]
    }]
  }
}
```

validate-command.sh が exit 2 を返すとコマンド実行が**ブロックされ**、Claude にはブロック理由が伝わります。Auto Mode の上に追加のカスタムルールを重ねられます。

#### PostToolUse でツール出力を置換・計測する

v2.1.121 から、`PostToolUse` フックは `hookSpecificOutput.updatedToolOutput` を返すことで**全ツール**の出力を置換できるようになった (以前は MCP ツールのみ)。ログ整形やセンシティブ情報のマスクに活用できる。

また v2.1.119 から、`PostToolUse` / `PostToolUseFailure` の入力に `duration_ms` (ツール実行時間、ミリ秒) が含まれるようになった。遅いツールのアラートやパフォーマンスログの構築に使える。

### 5.5 Agent Teams — 複数 Claude の協調 (実験機能)

**2026 年 2 月に登場した実験機能**。Subagent は「親が子を呼んで結果を受け取る」一方向モデルですが、Agent Teams は **複数の Claude Code インスタンスが互いに直接メッセージを送り合い、共有タスクリストから仕事を取り合う** モデルです。

実例: Next.js マイグレーションで、1 体が API routes のリファクタ、1 体が React コンポーネント更新、1 体が統合テスト作成を並行し、互いに `TaskCompleted` / `TeammateIdle` イベントでシグナルを送り合う。

#### 有効化 (実験機能)

```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

#### トレードオフ

- **標準セッションの約 15 倍のトークン消費**
- 観測性が弱い (誰が何をしているか見づらい)
- 真にパスが独立なタスクでのみ効果的

### 5.6 MCP Servers — 「配管」の役割

MCP (Model Context Protocol) サーバーは、**Claude に新しい「手足」を提供** する外部プロセスです。Claude は MCP が露出したツールを、Read や Bash と同じように呼び出せます。

#### MCP / Skill / Plugin の違いを一言で

> **Skills は Claude に教える。MCP は Claude に手足を与える。Plugins は上記を束ねて配る。**

#### 設定場所 (階層は 2025 年当時と同じ)

| スコープ | 設定場所 |
|---|---|
| Enterprise (管理者強制) | `/Library/Application Support/ClaudeCode/policies.json` |
| Global (自分) | `claude mcp add` コマンド |
| Project (チーム共有) | `.mcp.json` (**コミットする**) |
| Project (自分のみ) | `claude mcp add` with `--scope project` |

#### `alwaysLoad` オプション (v2.1.121 〜)

MCP サーバー設定で `alwaysLoad: true` を指定すると、そのサーバーのツールがツール検索の遅延対象から外れ、セッション開始時から常時利用可能になる。頻繁に使う MCP サーバーに設定すると初回呼び出しの遅延を排除できる。

```json
// .mcp.json または ~/.claude/settings.json
{
  "mcpServers": {
    "my-always-on-server": {
      "command": "npx my-mcp-server",
      "alwaysLoad": true
    }
  }
}
```

#### 代表的な MCP サーバー (2026 年)

プラグインマーケットプレイスからワンコマンドでインストールできる主要 MCP:

```bash
/plugin install github@claude-plugins-official
/plugin install playwright@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install postgres@claude-plugins-official
```

より詳しくは次章で。

---
