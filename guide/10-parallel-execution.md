---
title: "9. 並列・自律実行"
last_updated: 2026-04-17
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

**非 Git VCS** (Mercurial / Perforce / SVN) 向けには、`WorktreeCreate` / `WorktreeRemove` フックを `settings.json` で定義すれば同じ分離が得られます。

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

### 9.7 `/rewind` — 間違えたら巻き戻し

**2026 年に追加された最も便利な機能の 1 つ**。会話とコード変更をまとめて任意の時点まで巻き戻し:

```bash
/rewind
```

Interactive にどこまで戻すかを選べます。Esc Esc の強化版で、**ファイルシステムの変更まで取り消す**のがポイント。「Claude に任せて 20 ファイル編集させたけど方向が違った」を怖くなくします。

### 9.8 並列パターンのまとめ (2026 年版)

| レベル | 方法 | 適するケース |
|---|---|---|
| 初心者 | 複数ターミナルタブ + `/add-dir` | 別タスクを同時進行 |
| 初級 | `claude --worktree --tmux` | 同リポジトリの別ブランチ作業 |
| 中級 | Subagents (`.claude/agents/`) | 単一タスクの並列分解 |
| 上級 | Agent Teams (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) | 独立パスが明確なマルチロール作業 |
| 自動化 | Scheduled Tasks (`/schedule`) | 定期実行の自律タスク |
| リモート | Remote Control / Channels | 長時間タスクのモバイル監視 |

---
