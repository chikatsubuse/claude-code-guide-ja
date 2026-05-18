# Weekly Update: 2026-W20

## 概要
- CHANGELOG: v2.1.114 → v2.1.138 (17 リリース)
- 新着ブログ: 0 本
- ガイドへの反映: 8 ファイル

## 🔴 Breaking

なし

## 🟠 Major

- **`autoMode.hard_deny`** (v2.1.136): Auto Mode の無条件ブロックルール。`soft_deny` と違いユーザー許可でも通らない → `guide/05-auto-mode-computer-use.md`
- **`worktree.baseRef`** (v2.1.133): worktree の分岐元を `fresh`(origin) / `head`(ローカル HEAD) で選択可 → `guide/10-parallel-execution.md`
- **Hooks で effort level 参照** (v2.1.133): `effort.level` / `$CLAUDE_EFFORT` が Hooks と Bash ツール内で使用可能に → `guide/06-extension-mechanisms.md`
- **MCP Tool hook** (v2.1.118): `type: "mcp_tool"` で Hook から MCP ツールを直接呼び出せるように → `guide/06-extension-mechanisms.md`
- **PostToolUse 全ツール対応** (v2.1.121): `hookSpecificOutput.updatedToolOutput` が全ツールで使用可能に (従来は MCP のみ) → `guide/06-extension-mechanisms.md`
- **`alwaysLoad` MCP オプション** (v2.1.121): MCP ツールを tool-search の遅延なく常時ロード → `guide/06-extension-mechanisms.md`
- **`--plugin-url <url>`** (v2.1.129): URL から plugin .zip を直接フェッチ → `guide/07-plugin-marketplace.md`
- **`--plugin-dir` が .zip 対応** (v2.1.128): zip アーカイブを直接渡せるように → `guide/07-plugin-marketplace.md`
- **`claude plugin prune`** (v2.1.121): 孤立した依存プラグインを削除 → `guide/07-plugin-marketplace.md`
- **vim visual mode** (v2.1.118): `v`/`V` でビジュアル選択・行選択モード → `guide/11-keybindings-cheatsheet.md`
- **`/usage` 統合** (v2.1.118): `/cost` + `/stats` → `/usage` に統合 (旧コマンドはショートカットで継続) → `guide/11-keybindings-cheatsheet.md`
- **カスタムテーマ** (v2.1.118): `/theme` でカスタムテーマ作成・切替が正式対応 → `guide/02-setup.md`
- **デフォルト effort が `high` に** (v2.1.117): Pro/Max の Opus 4.6・Sonnet 4.6 のデフォルトが `medium` → `high` → `guide/02-setup.md`
- **`claude ultrareview [target]`** (v2.1.120): `/ultrareview` の非対話 CI 向けサブコマンド → `guide/11-keybindings-cheatsheet.md`, `guide/appendix-b-commands.md`
- **`--channels` コンソール認証対応** (v2.1.128): API キー認証でも `--channels` が使用可能に → `guide/10-parallel-execution.md`

## 🟡 Minor

- Windows: Git for Windows 不要になった (PowerShell にフォールバック, v2.1.120)
- `${CLAUDE_EFFORT}` プレースホルダー: Skill 本文から effort 参照可 (v2.1.120)
- `claude plugin tag`: リリース Git タグ作成コマンド (v2.1.118)
- `sandbox.bwrapPath`/`socatPath`: Linux/WSL での管理者向け設定 (v2.1.133)
- `claude project purge [path]`: プロジェクト状態の全削除 `--dry-run` 対応 (v2.1.126)

## 📝 ブログ

新着なし

## 📖 変更ファイル

- `guide/02-setup.md`: Windows Git for Windows 不要化、デフォルト effort `high`、カスタムテーマ対応
- `guide/05-auto-mode-computer-use.md`: `autoMode.hard_deny` セクション追加、`sandbox.bwrapPath`/`socatPath` 追記
- `guide/06-extension-mechanisms.md`: MCP tool hook type、PostToolUse 全ツール対応、effort in hooks、`alwaysLoad`、`${CLAUDE_EFFORT}`
- `guide/07-plugin-marketplace.md`: `--plugin-url`/`.zip` 対応、§6.8 管理コマンド表追加
- `guide/10-parallel-execution.md`: `worktree.baseRef` 設定、`--channels` コンソール認証対応
- `guide/11-keybindings-cheatsheet.md`: vim visual mode (`v`/`V`)、`/usage` 統合、`claude ultrareview`
- `guide/appendix-a-timeline.md`: 4 行追加 (v2.1.118〜v2.1.136)
- `guide/appendix-b-commands.md`: `claude ultrareview`、`claude project purge`、`claude plugin prune`、`claude plugin tag`、`claude --plugin-url` 追加
- `state/weekly-summaries/2026-W20.md`: 新規作成
- `state/last-changelog-sha.txt`: `0385848b` → `831608a3` に更新
- `state/last-changelog-version.txt`: `2.1.114` → `2.1.138` に更新
- `state/last-blog-urls.json`: `last_checked` を 2026-05-11 に更新

---

レビューポイント:
- [ ] **デフォルト effort `high` への引き上げ** (v2.1.117): Opus 4.6/Sonnet 4.6 でのコスト増加についてユーザーへの注意喚起が必要か確認
- [ ] **`worktree.baseRef` の挙動変更**: v2.1.128 で local HEAD に変更 → v2.1.133 で origin に戻す。既存ユーザーへの影響として破壊的変更として扱うべきか確認
- [ ] `claude ultrareview` の反映先が `11-keybindings-cheatsheet.md` §10.6 で適切か (専用の節を設けるほどの機能か)
- [ ] `claude project purge` はガイドの別の章 (例: team-context や setup) にも言及すべきか
