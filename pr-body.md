# Weekly Update: 2026-W21

## 概要
- CHANGELOG: v2.1.138 → v2.1.143 (5 リリース)
- 新着ブログ: 0 本
- ガイドへの反映: 7 章ファイル

## 🔴 Breaking
なし

## 🟠 Major
- **Agent ビュー** (v2.1.139): `claude agents` コマンドで全セッションを一画面表示 (リサーチプレビュー)。v2.1.142〜 で `--model`/`--effort`/`--permission-mode`/`--add-dir` 等の起動フラグを追加
- **`/goal` コマンド** (v2.1.139): 完了条件を設定すると Claude が自律継続実行。経過時間/ターン/トークンをオーバーレイ表示
- **Plugin 依存強制** (v2.1.143): `claude plugin disable` が依存チェックで拒否、`enable` が推移的依存を自動有効化
- **`/plugin` Projected Cost** (v2.1.143): マーケットプレイス Browse ペインにトークン推定コストを表示
- **`worktree.bgIsolation: none`** (v2.1.143): worktree 利用不可リポジトリでバックグラウンドセッションが作業ツリーを直接編集
- **Fast モード Opus 4.7 デフォルト** (v2.1.142): Fast モードのデフォルトモデルが Opus 4.6 → Opus 4.7 に変更
- **Hook `terminalSequence`** (v2.1.141): フック出力からデスクトップ通知・ウィンドウタイトル・ベル音を発行可能

## 🟡 Minor
- Hook `args: string[]` (v2.1.139): exec 形式でシェル不要のコマンド直接起動
- Hook `continueOnBlock` (v2.1.139): PostToolUse 拒否時にターンを継続させる新オプション
- MCP `CLAUDE_PROJECT_DIR` (v2.1.139): stdio サーバー環境に自動挿入
- Plugin root-level SKILL.md (v2.1.142): skills/ サブディレクトリなしでルートの SKILL.md が Skill 認識
- `claude plugin details` (v2.1.139): コンポーネント一覧・推定トークンコストを表示
- `/scroll-speed` (v2.1.139): マウスホイールスクロール速度調整コマンド追加

## 📝 ブログ
新着なし

## 📖 変更ファイル
- `guide/02-setup.md`: Fast モード Opus 4.7 デフォルト変更 (§1.3)
- `guide/06-extension-mechanisms.md`: Hook 新設定項目・MCP CLAUDE_PROJECT_DIR 追記 (§5.4, §5.6)
- `guide/07-plugin-marketplace.md`: Plugin 依存強制・Projected cost・root-level SKILL.md・plugin details/disable/enable 追記 (§6.2, §6.6, §6.8)
- `guide/10-parallel-execution.md`: worktree.bgIsolation 追記 (§9.1)、Agent ビュー新節 §9.9 追加、§9.8 表更新
- `guide/11-keybindings-cheatsheet.md`: /goal・/scroll-speed・claude agents 追記
- `guide/appendix-a-timeline.md`: 3 行追加
- `guide/appendix-b-commands.md`: /goal・claude agents・plugin details/disable/enable 追記
- `state/weekly-summaries/2026-W21.md`: 新規作成
- `state/last-changelog-sha.txt`, `state/last-changelog-version.txt`, `state/last-blog-urls.json`: 状態更新

---
レビューポイント:
- [ ] `claude agents` は「リサーチプレビュー」と明記しているが、GA 扱いに変更すべきか要確認
- [ ] `/goal` の配置: 現在は 10.3「作業中コマンド」に追記したが、9 章「並列・自律実行」にも節を設けるべきか
- [ ] Fast モード Opus 4.7 デフォルト変更が既存ユーザーにとって Breaking に近いか要確認
- [ ] `terminalSequence` の具体的な JSON 形式が CHANGELOG 未記載 — 公式ドキュメント確認後に詳細追記推奨
