---
title: "付録 B — コマンド早見表"
last_updated: 2026-04-17
chapter_id: appendix-b-commands
---

## 付録 B — コマンド早見表

```bash
# ─── インストールと認証 ───────────────────────
curl -fsSL https://claude.ai/install.sh | bash   # 推奨
npm install -g @anthropic-ai/claude-code         # 代替
/login                                           # claude.ai 認証

# ─── 起動直後のセットアップ ───────────────────
/terminal-setup                                  # Shift+Enter 改行
/theme                                           # テーマ
/install-github-app                              # GitHub 連携
/config                                          # 通知 / Voice / Auto Mode
/permissions                                     # 権限編集

# ─── 対話中の基本操作 ─────────────────────────
#<メモ>                                          # CLAUDE.md へ自動追記
!<bash>                                          # Bash 実行 + コンテキスト取込
@<path>                                          # ファイル/フォルダ注入
Shift+Tab                                        # Auto-accept モード
Esc / Esc Esc                                    # キャンセル / 履歴ジャンプ
Ctrl+R                                           # 詳細出力切替
/memory                                          # メモリ階層確認
/context                                         # コンテキスト使用量
/rewind                                          # コード変更ごと巻き戻し

# ─── モデルと深さ ─────────────────────────────
/model                                           # モデル切替
/effort                                          # Opus 4.7 深さ調整

# ─── 拡張機構 ─────────────────────────────────
/agents                                          # Subagent 作成ウィザード
/plugin                                          # Plugin Marketplace UI
/plugin install <n>@<marketplace>             # プラグインインストール
/plugin marketplace add <github-url>             # マーケットプレイス追加
/reload-plugins                                  # プラグインリロード
/mcp                                             # MCP 管理
claude mcp add <n> -- <command>               # MCP サーバー追加

# ─── 組み込み Skill ───────────────────────────
/init                                            # CLAUDE.md 自動生成
/review                                          # コードレビュー
/security-review                                 # セキュリティレビュー
/simplify                                        # コード簡素化
/debug                                           # 構造化デバッグ
/powerup                                         # 対話チュートリアル

# ─── 並列・自律実行 ───────────────────────────
claude --worktree [NAME] [--tmux]                # Git worktree 分離
claude --add-dir <path>                          # 別リポジトリを追加
/branch                                          # セッションを枝分かれ
claude --resume <session-id> --fork-session      # 履歴を分岐
/schedule                                        # Cron 実行設定
/remote-control                                  # スマホ/Web からの制御
claude remote-control                            # 新規リモートセッション

# ─── Agent SDK (非対話モード) ─────────────────
claude -p "<prompt>" --bare                      # 基本形 (高速起動)
claude -p "<prompt>" \
  --bare \
  --allowedTools "Bash(git log:*),Read,Edit" \
  --permission-mode acceptEdits \
  --output-format json \
  --model sonnet-4-6 \
  --effort high

# ─── Python SDK ───────────────────────────────
# pip install claude-agent-sdk
from claude_agent_sdk import query, ClaudeAgentOptions
async for msg in query(prompt="...", options=ClaudeAgentOptions(
    allowed_tools=["Read","Edit"],
    setting_sources=["user","project"]
)):
    print(msg)

# ─── TypeScript SDK ──────────────────────────
// npm install @anthropic-ai/claude-agent-sdk
import { query } from '@anthropic-ai/claude-agent-sdk';
for await (const m of query({ prompt: "...", options: {
    allowedTools: ["Read","Edit"],
    settingSources: ["user","project"]
}})) { console.log(m); }
```

---
