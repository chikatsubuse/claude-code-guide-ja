# Weekly Update: 2026-W19

## 概要
- CHANGELOG: v2.1.114 → v2.1.126 (9 リリース: .116〜.126)
- 新着ブログ: 0 本
- ガイドへの反映: 6 ファイル

## 🔴 Breaking
なし

## 🟠 Major
- **claude project purge** (v2.1.126): プロジェクト状態を一括削除。--dry-run/-y/--interactive/--all 付き
- **claude ultrareview** (v2.1.120): CI から /ultrareview を非対話実行。--json で raw 出力
- **MCP alwaysLoad** (v2.1.121): MCP サーバー設定に alwaysLoad:true でツールを常時ロード
- **claude plugin prune** (v2.1.121): 孤立した自動インストール済み依存を一括削除
- **PostToolUse で全ツール出力を置換** (v2.1.121): hookSpecificOutput.updatedToolOutput が全ツールに対応
- **Vim visual mode** (v2.1.118): v/V でビジュアル選択、オペレータ適用可
- **/usage 統合** (v2.1.118): /cost と /stats を /usage に統合。旧コマンドはショートカット継続
- **カスタムテーマ作成** (v2.1.118): /theme で名前付きテーマ作成・切替・プラグイン配布
- **Hooks から MCP ツール呼出** (v2.1.118): type:mcp_tool フックハンドラを追加

## 🟡 Minor
- デフォルト effort が high に変更 (v2.1.117): Pro/Max の Opus 4.6・Sonnet 4.6 が medium → high
- CLAUDE_EFFORT プレースホルダ (v2.1.120): Skill 本文から現在の effort レベルを参照可
- /skills 検索ボックス (v2.1.121): Skill 一覧をキーワードで絞り込み可
- PostToolUse に duration_ms 追加 (v2.1.119): ツール実行時間をフック入力で取得可
- ANTHROPIC_BEDROCK_SERVICE_TIER 環境変数 (v2.1.122): Bedrock サービスティア選択
- claude auth login ターミナル貼り付け認証 (v2.1.126): WSL2/SSH/コンテナ対応

## 📝 ブログ
なし (今週は新着なし)

## 📖 変更ファイル
- `guide/02-setup.md`: §1.3 にデフォルト effort 変更の注記追加。§1.4 にカスタムテーマ説明を追加
- `guide/06-extension-mechanisms.md`: §5.2/5.4/5.6 に新機能を追記
- `guide/07-plugin-marketplace.md`: §6.2 に claude plugin prune を追記
- `guide/11-keybindings-cheatsheet.md`: Vim visual mode / /usage / /ultrareview を追加
- `guide/appendix-b-commands.md`: project purge / ultrareview / plugin prune / /usage を追加
- `guide/appendix-a-timeline.md`: v2.1.118〜v2.1.126 の主要イベント 6 行を追加
- `state/weekly-summaries/2026-W19.md`: 新規作成
- `state/last-changelog-sha.txt`: 5bf19945... に更新
- `state/last-changelog-version.txt`: 2.1.126 に更新
- `state/last-blog-urls.json`: last_checked を更新

---
レビューポイント:
- [ ] デフォルト effort high 変更は Minor 扱いだが、ユーザへの影響が大きい場合は Major に格上げを検討
- [ ] /cost・/stats はショートカットとして動作継続するが、案内文言の更新要否を確認
- [ ] claude project purge は破壊的操作のため、README への警告追加が必要か確認
- [ ] タイムラインの日付は推定値。正確なリリース日が判明した場合は修正を推奨
