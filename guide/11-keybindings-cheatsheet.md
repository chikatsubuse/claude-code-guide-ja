---
title: "10. キーバインド & スラッシュコマンド早見表"
last_updated: 2026-05-04
chapter_id: 11-keybindings-cheatsheet
---

## 10. キーバインド & スラッシュコマンド早見表

講演当時の 8 項目から、2026 年には大幅に増えています。よく使うものだけ厳選して掲載。

### 10.1 キーバインド (講演から継続 + 新規)

| キー | 動作 | 備考 |
|---|---|---|
| `Shift + Tab` | Auto-accept モード切替 | 編集を自動承認。Esc で戻る |
| `#` | メモ記憶 (CLAUDE.md 自動追記) | どこに保存するか対話選択 |
| `!` | Bash モード | ローカル実行 + コンテキスト取込 |
| `@` | ファイル/フォルダをコンテキスト追加 | Tab 補完あり |
| `Esc` | 処理キャンセル | セッション保持 |
| `Esc Esc` | 履歴を遡る | 過去ターンへジャンプ |
| `Ctrl + R` | 詳細出力 (verbose) 切替 | Claude が見ている全文を確認 |
| `Ctrl + O` | 通常/詳細トランスクリプト切替 | 2026 年改修 |
| `Ctrl + G` | 外部エディタで編集 | プロンプトを `$EDITOR` で編集 |
| `Ctrl + A` | 複数行入力の行頭へ移動 | v2.1.113: readline 互換動作 |
| `Ctrl + E` | 複数行入力の行末へ移動 | v2.1.113: readline 互換動作 |
| `v` / `V` | Vim visual / visual-line モード | Vim モード時。選択範囲にオペレータを適用可 (v2.1.118〜) |

### 10.2 スラッシュコマンド — セットアップ

| コマンド | 効果 |
|---|---|
| `/terminal-setup` | Shift+Enter 改行 |
| `/theme` | テーマ変更 (Auto-match も可) |
| `/install-github-app` | GitHub `@claude` メンション有効化 |
| `/config` | 設定画面 (通知, Voice, Auto Mode, Output Style, Remote Control) |
| `/permissions` | 権限ルール編集 (旧 `/allowed-tools`) |
| `/login` | claude.ai 認証 |
| `/model` | モデル切替 (途中変更は警告あり) |
| `/effort` | Opus 4.7 の深さ調整 (low/medium/high/xhigh/max) |

### 10.3 スラッシュコマンド — 作業中

| コマンド | 効果 |
|---|---|
| `/memory` | メモリ階層一覧と編集 |
| `/context` | 現在のコンテキスト使用量 |
| `/usage` | コスト・トークン使用量 (旧 `/cost`, `/stats` を統合) (v2.1.118〜) |
| `/compact` | 手動でコンテキスト圧縮 |
| `/clear` | 履歴をクリア |
| `/recap` | 離席明けにこれまでの要約を表示 |
| `/resume` | 過去セッション再開 |
| `/branch` | 現セッションから枝分かれ |
| `/rewind` | コード変更ごと巻き戻し |
| `/focus` | Focus モード (最終結果のみ表示) |
| `/tui fullscreen` | ちらつきなし全画面 |

### 10.4 スラッシュコマンド — 拡張

| コマンド | 効果 |
|---|---|
| `/agents` | Subagent の作成・管理 (/agents でウィザード) |
| `/plugin` | Plugin Marketplace UI |
| `/reload-plugins` | プラグイン再読み込み |
| `/mcp` | MCP サーバー管理 |
| `/init` | 新規プロジェクトに CLAUDE.md 初期作成 |
| `/review` | Claude に PR/コードレビューさせる |
| `/security-review` | セキュリティレビュー (組み込み Skill) |
| `/simplify` | コード簡素化 (組み込み Skill) |
| `/debug` | 構造化デバッグ (組み込み Skill) |
| `/powerup` | インタラクティブ機能チュートリアル |
| `/ultrareview` | 高精度コードレビュー (v2.1.120〜) |

### 10.5 スラッシュコマンド — リモート・スケジュール

| コマンド | 効果 |
|---|---|
| `/remote-control` | スマホ/Web からの制御を有効化 |
| `/schedule` | Cron 実行セットアップ |
| `/rename` | セッション名変更 (複数端末で識別) |

### 10.6 起動オプション (代表例)

```bash
claude                             # 対話モード
claude -p "..."                    # ヘッドレス (Agent SDK CLI)
claude -p "..." --bare             # SDK 用高速起動
claude --resume                    # 前回セッション再開
claude --continue                  # 続きから再開
claude --worktree                  # git worktree で分離起動
claude --worktree NAME --tmux      # tmux + worktree
claude --auto                      # Auto Mode で起動
claude --computer-use              # Computer Use 有効化
claude --add-dir PATH              # 追加作業ディレクトリ
claude --model opus-4-7            # モデル指定
claude --effort xhigh              # 推論深度指定
claude remote-control              # 新規リモートセッション
```

---
