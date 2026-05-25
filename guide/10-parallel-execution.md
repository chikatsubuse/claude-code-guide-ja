---
title: "9. 並列・自律実行"
last_updated: 2026-05-25
chapter_id: 10-parallel-execution
---

## 9. 並列・自律実行

講演の **Interlude: Multi-claude** は 4 手法でしたが、2026 年には大幅拡張されています。

### 9.1 Worktree のネイティブサポート (2026 年)

講演時は手作業で git worktree を作って tmux を立ち上げていましたが、**2026 年は Claude Code がネイティブサポート**。

```bash
claude --worktree                    # 自動生成された worktree でセッション起動
claude --worktree feature-auth       # 名前付き
claude --worktree feature-auth --tmux   # tmux セッションで起動
```

デスクトップアプリでは Code タブの worktree チェックボックスで有効化。

v2.1.133 で `worktree.baseRef` 設定が追加された。`fresh` (デフォルト: `origin/<default-branch>` から分岐) と `head` (ローカル `HEAD` から分岐) を選べる。未プッシュのコミットを新しい worktree に引き継ぎたい場合は `head` を指定する:

```json
// ~/.claude/settings.json
{
  "worktree": {
    "baseRef": "head"
  }
}
```

**非 Git VCS** (Mercurial / Perforce / SVN) 向けには、`WorktreeCreate` / `WorktreeRemove` フックを `settings.json` で定義すれば同じ分離が得られます。

v2.1.143 で `worktree.bgIsolation: "none"` 設定が追加された。バックグラウンドセッションが `EnterWorktree` を呼ばずに作業コピーを直接編集できるようになり、worktree が使えないリポジトリ (サブモジュール構成など) での利用に適している:

```json
// ~/.claude/settings.json
{
  "worktree": {
    "bgIsolation": "none"
  }
}
```

### 9.2 `/add-dir` でクロスリポジトリ作業

複数リポジトリにまたがる作業では:

```bash
claude --add-dir ../other-repo ../shared-libs
# またはセッション中に
/add-dir ../other-repo
```

チーム共通で常に追加するディレクトリは `settings.json` に:

```json
{
  "additionalDirectories": ["../shared-libs"]
}
```

### 9.3 `/branch` と `--fork-session`

既存セッションから枝分かれした探索を始めたいとき:

```bash
# セッション内から
/branch

# CLI から
claude --resume <session-id> --fork-session
```

### 9.4 Agent Teams (実験機能)

5.5 章で紹介した **Agent Teams** は、Multi-claude の最先端パターン。複数の Claude Code が共有タスクリストから仕事を取り、互いにメッセージングします。`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` で有効化。

### 9.5 Scheduled Tasks — Cron としての Claude Code

**2026 年 3 月に登場した最重要機能の 1 つ**。Claude Code がローカル端末に縛られず、**Anthropic マネージドクラウドで定期実行** できるようになりました。

```bash
/schedule
```

対話的に設定:
- プロンプト
- リポジトリ (複数アタッチ可)
- スケジュール (cron 形式)
- 環境変数、MCP コネクタ

**典型ユースケース**:
- 毎朝 9 時、開いている PR をレビュー
- 毎晩、CI 失敗を要約して Slack へ投稿
- 毎週月曜、依存関係の脆弱性監査
- 毎日夜、ドキュメントを最新コードと同期

各実行はフレッシュなクローンから始まり、独立したセッションで走ります。結果は Web UI で確認して、そのまま PR を開けます。

### 9.6 Remote Control — スマホから制御

**2026 年 2 月に登場**。ローカルで走っている Claude Code セッションを、**スマホや Web から直接操作** できる同期レイヤー。

```bash
/remote-control
```

(または起動時に `claude remote-control` で新セッションを開く)

- セッションは**あなたのマシンで走り続ける** (クラウド移行ではない)
- claude.ai/code / iOS アプリ / Android アプリから同じセッションに接続
- ローカルの `CLAUDE.md` / カスタム Skill / MCP 統合はすべて生きたまま

**Pro/Max プラン限定**、v2.1.51 以降。

#### Channels — Telegram / Discord / Slack から制御

Remote Control のバリエーション。メッセージアプリから Claude Code を操作:

```bash
/plugin install discord-bridge
# または
/plugin install telegram-bridge
```

`@claude-code` とメンションするだけで、通勤中でもスマホから長時間タスクを制御できます。

v2.1.128 で `--channels` フラグがコンソール認証 (API キー) でも動作するようになった。コンソール組織で利用するには managed settings に `channelsEnabled: true` を設定する必要がある。

### 9.7 `/rewind` — 間違えたら巻き戻し

**2026 年に追加された最も便利な機能の 1 つ**。会話とコード変更をまとめて任意の時点まで巻き戻し:

```bash
/rewind
```

Interactive にどこまで戻すかを選べます。Esc Esc の強化版で、**ファイルシステムの変更まで取り消す**のがポイント。「Claude に任せて 20 ファイル編集させたけど方向が違った」を怖くなくします。

v2.1.141 から Rewind メニューに **"Summarize up to here"** オプションが追加された。選択した時点までの会話を圧縮しつつ、それより新しいターンを intact のまま保持する。コンテキストが溢れてきたとき、全履歴を捨てずに古い部分だけ要約できる。

### 9.8 並列パターンのまとめ (2026 年版)

| レベル | 方法 | 適するケース |
|---|---|---|
| 初心者 | 複数ターミナルタブ + `/add-dir` | 別タスクを同時進行 |
| 初級 | `claude --worktree --tmux` | 同リポジトリの別ブランチ作業 |
| 中級 | Subagents (`.claude/agents/`) | 単一タスクの並列分解 |
| 上級 | Agent Teams (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) | 独立パスが明確なマルチロール作業 |
| 自動化 | Scheduled Tasks (`/schedule`) | 定期実行の自律タスク |
| リモート | Remote Control / Channels | 長時間タスクのモバイル監視 |
| 管理 UI | Agent View (`claude agents`) | 全バックグラウンドセッションの一覧・監視 |

### 9.9 Agent View — `claude agents` **(Research Preview, v2.1.139〜)**

**2026 年 5 月に Research Preview として登場。** 実行中・待機中・完了済みのすべての Claude Code セッションを 1 画面で管理できる専用 UI。

```bash
claude agents               # Agent View を起動
claude agents --json        # JSON でセッション一覧出力 (tmux-resurrect / status bar 向け)
claude agents --cwd <path>  # 特定ディレクトリのセッションに絞り込み
```

主な機能:

- **セッション一覧**: running / blocked (ユーザー入力待ち) / done の状態が一目で分かる
- **アタッチ/デタッチ**: `←` / `→` でセッションへ接続・切り離し
- **ピン留め** (`Ctrl+T`): ピン留めしたバックグラウンドセッションはアイドル状態でも生存し続け、アップデート適用時もその場で再起動
- **インラインリネーム** (`Ctrl+R`): セッション名をその場で変更
- **フラグ引き継ぎ**: `--add-dir`, `--settings`, `--mcp-config`, `--plugin-dir`, `--permission-mode`, `--model`, `--effort` などを `claude agents` 起動時に指定すると、そのダッシュボードから派生するセッションにも適用される

`/resume` は v2.1.144 からバックグラウンドセッション (`claude --bg` で起動したもの) にも対応した。セッション選択肢に `bg` マーカーが付いて表示される。

詳細は [公式ドキュメント (英語)](https://code.claude.com/docs/en/agent-view) を参照。

---
