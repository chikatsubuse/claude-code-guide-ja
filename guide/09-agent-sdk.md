---
title: "8. Agent SDK (旧 Claude Code SDK)"
last_updated: 2026-04-17
chapter_id: 09-agent-sdk
---

## 8. Agent SDK (旧 Claude Code SDK)

### 8.1 名前と位置付けの変化

**2025 年 5 月**: "Claude Code SDK"、CLI のみ、TS/Python SDK は「近日公開」予定。

**2026 年 4 月**: **"Agent SDK"** に改名。**Python と TypeScript のパッケージが GA**。Claude Code と同じツール、エージェントループ、コンテキスト管理を提供。Claude Code は「Agent SDK を使って作られた参照実装」という位置付けに昇格しました。

**対応バックエンド**: Anthropic API / AWS Bedrock / Google Vertex AI / Azure AI Foundry

### 8.2 CLI モード (講演で紹介されたもの)

```bash
claude -p "Find and fix the bug in auth.py" --allowedTools "Read,Edit,Bash"
```

主要オプション:

```bash
claude -p "..." \
  --allowedTools "Bash(npm test:*),Read,Edit" \   # 個別許可
  --permission-mode acceptEdits \                 # 権限モード
  --output-format json \                          # stream-json も可
  --model opus-4-7 \                              # モデル指定
  --effort xhigh \                                # 深さ指定
  --settings path/to/settings.json \              # 設定明示
  --system-prompt path/to/prompt.md \             # SP 明示
  --mcp-config path/to/mcp.json \                 # MCP 明示
  --bare                                          # ※ 下記
```

#### ★ `--bare` フラグ (2026 年の重要な新機能)

講演時にはなかった概念。`claude -p` は既定で **ローカルの CLAUDE.md / settings / MCP / skill をスキャン** しますが、これが SDK やスクリプト用途では邪魔になり、起動が遅くなります。

```bash
claude -p "summarize this codebase" \
  --output-format=stream-json \
  --bare     # ~10 倍速くなる。ANTHROPIC_API_KEY 必須
```

**公式ドキュメントから**: 「これは SDK 初設計時の見落としで、将来版では `-p` のデフォルトが `--bare` に変わる予定」。2026 年時点では明示的オプトインが必要。CI ではほぼ常に `--bare` を付けるのが正解です。

### 8.3 Python SDK (GA)

```python
# pip install claude-agent-sdk
from claude_agent_sdk import query, ClaudeAgentOptions

async for message in query(
    prompt="Help me refactor the auth module",
    options=ClaudeAgentOptions(
        allowed_tools=["Read", "Edit", "Glob", "Bash"],
        permission_mode="acceptEdits",
        setting_sources=["user", "project"],   # CLAUDE.md / Skills をロード
        system_prompt="You are a senior Python developer. Follow PEP 8.",
        model="claude-sonnet-4-6"
    )
):
    print(message)
```

#### 重要な新概念: `setting_sources`

**デフォルトでは SDK は CLAUDE.md も Skills もロードしない**。これは CLI (`claude -p`) と異なる重要な挙動差。明示的にロードさせるには:

```python
setting_sources=["user", "project"]   # ~/.claude/ と ./.claude/ を読む
# または CLI と完全互換:
setting_sources=["user", "project", "local"]
```

### 8.4 TypeScript SDK (GA)

```typescript
// npm install @anthropic-ai/claude-agent-sdk
import { query } from '@anthropic-ai/claude-agent-sdk';

for await (const message of query({
  prompt: "Help me refactor the auth module",
  options: {
    allowedTools: ["Read", "Edit", "Glob", "Bash"],
    permissionMode: "acceptEdits",
    settingSources: ["user", "project"],
    model: "claude-sonnet-4-6"
  }
})) {
  console.log(message);
}
```

#### TypeScript 固有の機能

- **追加の Hook イベント**: `SessionStart`, `SessionEnd`, `TeammateIdle`, `TaskCompleted` (Python SDK にはまだない)
- **Structured Outputs**: `--output-format json` + `--json-schema` で JSON Schema 準拠出力を強制

### 8.5 Unix ユーティリティとしての使用 (講演の教えは健在)

Boris 氏が力説した「**Use the SDK as a unix utility: pipe in, pipe out**」は今も王道:

```bash
# 2025 年のまま動く基本形
git status | claude -p "what are my changes?" --bare --output-format=json | jq '.result'

# 2026 年の典型的パイプ
sentry-cli events list --format json | \
  claude -p "頻出エラーを優先度順に列挙して" --bare

git diff HEAD~1 | \
  claude -p "この変更を Slack 向けにカジュアルに要約" --bare

claude -p "What are the main architectural decisions in this repo?" --bare | \
  claude -p "Turn this into a 3-bullet onboarding summary" --bare
```

### 8.6 Managed Agents (2026 年新サービス)

**2026 年 4 月パブリックベータ**で登場した Anthropic ホスト型サービス。自分のサーバーで Agent SDK をホストせずに、Anthropic のマネージド環境で Claude を自律エージェントとして動かせます。

```bash
curl https://api.anthropic.com/v1/messages \
  -H "anthropic-beta: managed-agents-2026-04-01" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  ...
```

セキュアサンドボックス、組み込みツール、SSE ストリーミング付き。CI やサーバーレスから安全に呼び出したい場合に便利。

### 8.7 Advisor Tool (2026 年新機能)

**2026 年 3 月のベータ**。高速な Executor モデル (Sonnet/Haiku) と高知能な Advisor モデル (Opus) をペアにし、**長時間エージェント作業の途中で Advisor が戦略的指導を挟む** 仕組み。

```
Executor (Sonnet 4.6, fast) ── 作業の大半
       ↑
       │ (困ったら問い合わせ)
       ↓
Advisor (Opus 4.7, smart) ── 戦略判断だけ
```

コスト効率が劇的に改善 (大量トークン生成は安価モデル、重要判断だけ高価モデル)。`advisor-tool-2026-03-01` ベータヘッダで利用開始。

---
