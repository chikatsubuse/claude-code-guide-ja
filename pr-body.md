# Weekly Update: 2026-W22

## 概要
- CHANGELOG: v2.1.138 → v2.1.150 (11 リリース)
- 新着ブログ: 0 本
- ガイドへの反映: 7 ファイル (guide 6 章 + README)

## 🔴 Breaking

- **`/simplify` → `/code-review`** (v2.1.147): コマンドが改称され、旧 cleanup-and-fix 動作は廃止。新コマンドは effort 指定・`--comment` フラグで GitHub PR インラインコメント投稿に対応
- **`/model` が現セッション限定に変更** (v2.1.144): デフォルトモデルの変更は model picker 内の `d` キーで行う

## 🟠 Major

- **`claude agents` Agent View** (v2.1.139, Research Preview): 全セッション一覧 UI。`--json` でスクリプト向け出力、`--cwd` で絞り込み、Ctrl+T でピン留め
- **`/goal` コマンド** (v2.1.139): 完了条件を設定し達成まで自律継続
- **`claude plugin details <name>`** (v2.1.139): コンポーネント一覧と推定トークンコストを確認
- **Hook exec form / `continueOnBlock`** (v2.1.139): `args: string[]` でシェル不使用の直接起動、`continueOnBlock: true` でブロック後もターン継続
- **`terminalSequence` hook フィールド** (v2.1.141): ヘッドレス環境でのデスクトップ通知対応
- **プラグイン依存管理強制** (v2.1.143): disable/enable が依存関係を強制
- **`/resume` background sessions 対応** (v2.1.144): `claude --bg` セッションも再開可

## 🟡 Minor

- `/usage` per-category 内訳 (v2.1.149): skills/subagents/plugins/MCP 別コスト表示
- `worktree.bgIsolation: "none"` (v2.1.143): EnterWorktree なしで作業コピーを直接編集
- Rewind "Summarize up to here" (v2.1.141): 古い会話のみ圧縮
- Stop/SubagentStop フックに `background_tasks`/`session_crons` フィールド追加 (v2.1.145)
- root-level `SKILL.md` が Skill として認識 (v2.1.142)

## 📝 ブログ

今週の新着なし

## 📖 変更ファイル

- `README.md`: ⚠️ 今週の重要な変更セクションを追加
- `guide/10-parallel-execution.md`: 9.9 Agent View 節新設、9.1 worktree.bgIsolation、9.7 Rewind 追記、9.8 表更新
- `guide/06-extension-mechanisms.md`: Hook exec form/continueOnBlock/terminalSequence/Stop フィールド追記、/simplify→/code-review 更新
- `guide/07-plugin-marketplace.md`: plugin dependency enforcement、plugin details、root-level SKILL.md、projected cost 追記
- `guide/11-keybindings-cheatsheet.md`: /model、/code-review、/goal、/usage 更新
- `guide/appendix-b-commands.md`: /code-review、/goal、claude plugin details、claude agents 追加
- `guide/appendix-a-timeline.md`: v2.1.139〜v2.1.147 の 8 行追加
- `state/weekly-summaries/2026-W22.md`: 新規作成
- `state/last-changelog-sha.txt`, `state/last-changelog-version.txt`, `state/last-blog-urls.json`: 状態更新

---
レビューポイント:
- [ ] `/model` のセッション限定変更は 🔴 Breaking か 🟠 Major か (旧ドキュメントでは「途中変更は警告あり」としか書いておらず、デフォルト永続化の挙動は未記述のため Major 扱いでもよいかもしれない)
- [ ] `claude agents` は Research Preview のため **(プレビュー)** 表記をより強調すべきか確認
- [ ] `/goal` コマンドの反映先を keybindings のみにしたが、09-agent-sdk や 10-parallel-execution への記載が適切か確認
- [ ] v2.1.142 の「Fast mode now uses Opus 4.7 by default」を guide/02-setup.md に反映すべきか確認
