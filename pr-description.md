# Weekly Update: 2026-W18

## 概要
- CHANGELOG: v2.1.114 → v2.1.119 (4 リリース: v2.1.116, v2.1.117, v2.1.118, v2.1.119)
- 新着ブログ: 0 本
- ガイドへの反映: 8 ファイル

## 🔴 Breaking
なし

## 🟠 Major
- **Vim ビジュアルモード** (v2.1.118): `v` / `V` でテキスト・行単位の選択が可能に → `guide/11-keybindings-cheatsheet.md` §10.1
- **`/usage` 統合** (v2.1.118): `/cost` と `/stats` が `/usage` に集約 (旧コマンドはショートカットとして継続) → `guide/11-keybindings-cheatsheet.md` §10.3, `guide/appendix-b-commands.md`
- **カスタムテーマ対応** (v2.1.118): `/theme` から名前付きカスタムテーマ作成・切替が可能に → `guide/02-setup.md` §1.4
- **Hooks から MCP ツール直接呼び出し** (v2.1.118): `type: "mcp_tool"` ハンドラ追加で Hook ハンドラが 4 種類に → `guide/06-extension-mechanisms.md` §5.4
- **`claude plugin tag`** (v2.1.118): バージョン検証付きでリリース用 git タグ作成コマンド追加 → `guide/07-plugin-marketplace.md` §6.6
- **デフォルト effort が `high` に変更** (v2.1.117): Pro/Max の Opus 4.6・Sonnet 4.6 で `medium` → `high` → `guide/02-setup.md` §1.3

## 🟡 Minor
- `PostToolUse`/`PostToolUseFailure` フック入力に `duration_ms` 追加 (v2.1.119)
- `--agent` フロントマターの `hooks:` (v2.1.116) と `mcpServers:` (v2.1.117) がメインスレッドでも有効に
- Auto Mode に `"$defaults"` プレースホルダー追加 (v2.1.118)
- WSL 向け `wslInheritsWindowsSettings` ポリシーキー追加 (v2.1.118)
- `blockedMarketplaces` が全プラグイン操作に適用範囲拡大 (v2.1.117)
- Plugin 依存関係の自動補完改善 (v2.1.117/116)

## 📝 ブログ
なし (今週の新着ブログ記事なし)

## 📖 変更ファイル
- `guide/02-setup.md`: §1.3 にデフォルト effort `high` 変更の注記追加。§1.4 の `/theme` 説明にカスタムテーマ対応を追記
- `guide/05-auto-mode-computer-use.md`: §4.1 に `"$defaults"` サポートを追記
- `guide/06-extension-mechanisms.md`: §5.3 に `--agent` フロントマター対応を追記。§5.4 に `mcp_tool` ハンドラと `duration_ms` を追記
- `guide/07-plugin-marketplace.md`: §6.6 に `claude plugin tag` と依存解決改善を追記
- `guide/08-team-context.md`: §7.6 に WSL ポリシーキーと `blockedMarketplaces` 強化を追記
- `guide/11-keybindings-cheatsheet.md`: §10.1 に Vim ビジュアルモード、§10.3 に `/usage` を追加
- `guide/appendix-a-timeline.md`: v2.1.117-v2.1.118 主要リリース 5 行追加
- `guide/appendix-b-commands.md`: `/usage` と `claude plugin tag` を追加
- `state/weekly-summaries/2026-W18.md`: 新規作成
- `state/last-changelog-sha.txt`, `state/last-changelog-version.txt`, `state/last-blog-urls.json`: 状態更新

---
レビューポイント:
- [ ] **デフォルト effort `high` 変更** — Pro/Max 以外 (API キー直接利用等) も対象かどうか要確認。CHANGELOG には "Pro/Max subscribers on Opus 4.6 and Sonnet 4.6" と明記されている
- [ ] **`/usage` 統合** — `/cost` と `/stats` はショートカットとして残るが、今後廃止の可能性がある。将来的にガイドから旧コマンド表記を削除すべきか要検討
- [ ] **Hooks ハンドラ `mcp_tool` タイプ** — 詳細な設定構文が CHANGELOG に記載されていない。公式ドキュメント公開次第、ガイドにサンプルを追加すべきか
- [ ] **タイムラインの日付** — v2.1.116-v2.1.119 の正確なリリース日が CHANGELOG 差分に含まれていないため "2026/4下旬" と記載。正確な日付が判明したら修正を推奨
