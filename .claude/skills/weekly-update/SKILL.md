---
name: weekly-update
description: Execute the weekly update flow — read fetched CHANGELOG and blog diffs, reflect relevant changes into the guide, produce a weekly summary. Trigger when the user asks to "run weekly update", "reflect this week's changes", or "update the guide for this week".
---

# 週次更新フロー

このスキルは **週次で Claude Code の最新情報を日本語入門ガイドに反映する** メインフローである。

## 前提

以下のファイルが既に生成されていることが前提:

- `/tmp/changelog-diff.md` — `scripts/fetch-changelog-diff.sh` が生成した CHANGELOG 差分
- `/tmp/new-blog-posts.json` — `scripts/fetch-blog-diff.py` が生成した新着ブログ情報

もし存在しない場合は、以下を実行して生成する:

```bash
bash scripts/fetch-changelog-diff.sh
python3 scripts/fetch-blog-diff.py
```

## ステップ

### ステップ 1: 現在の状態を把握する

1. `@.claude/CLAUDE.md` を読んで編集ルールを確認
2. `@state/last-changelog-sha.txt` を読んで前回処理した SHA を確認
3. `@state/last-changelog-version.txt` を読んで前回の最新バージョンを確認
4. `@state/last-blog-urls.json` を読んで既読ブログ一覧を確認
5. `@guide/appendix-a-timeline.md` を読んで現在のタイムライン末尾を把握

### ステップ 2: 今週の材料を読み込む

1. `@/tmp/changelog-diff.md` を読む
   - 各リリース (例: `## 2.1.112`) を確認
   - セマンティックバージョン、リリース日、変更点をパース
2. `@/tmp/new-blog-posts.json` を読む
   - 新着記事のタイトル、URL、公開日を確認

### ステップ 3: 重要度を判定する

`.claude/CLAUDE.md` の「重要度判定基準」に従って各変更を分類する:

- 🔴 **Breaking** — 既存機能の破壊的変更
- 🟠 **Major** — 新モデル、新スラッシュコマンド、新拡張機構
- 🟡 **Minor** — 既存機能の改善
- 🔵 **Patch** — バグ修正
- ⚪ **Irrelevant** — 内部変更、CI 変更

**判断に迷う項目** は 🟠 Major 扱いにして PR 説明欄で人間に問う。

### ステップ 4: ガイドへの反映先をマッピング

各 🔴🟠🟡 変更について、反映先の章を決定:

| キーワード | 反映先の章 |
|---|---|
| 新モデル (Opus/Sonnet/Haiku) | `guide/02-setup.md` §1.3 "モデル選択" |
| `/effort`, モデル切替 | `guide/02-setup.md` §1.3 |
| 新スラッシュコマンド | `guide/11-keybindings-cheatsheet.md` + `guide/appendix-b-commands.md` |
| 新キーバインド | `guide/11-keybindings-cheatsheet.md` §10.1 |
| Skill / Subagent | `guide/06-extension-mechanisms.md` |
| Plugin / Marketplace | `guide/07-plugin-marketplace.md` |
| MCP 変更 | `guide/06-extension-mechanisms.md` §5.6 |
| Hooks 変更 | `guide/06-extension-mechanisms.md` §5.4 |
| Permission / Auto Mode | `guide/05-auto-mode-computer-use.md` |
| Computer Use | `guide/05-auto-mode-computer-use.md` §4.2 |
| SDK (Python/TS) 変更 | `guide/09-agent-sdk.md` |
| Worktree / 並列 | `guide/10-parallel-execution.md` |
| Scheduled / Remote / Channels | `guide/10-parallel-execution.md` §9.5-9.6 |
| チーム設定、CLAUDE.md 関連 | `guide/08-team-context.md` |
| Voice, IDE 拡張, インストール | `guide/02-setup.md` |

### ステップ 5: 該当章を編集する (最小 diff)

各章について:

1. 章ファイルを読む (例: `@guide/02-setup.md`)
2. **該当する節を特定** する
3. 既存の段落を **書き換えず、追記** を基本とする:
   - 表に行を追加
   - 節末尾に新しい段落 (1〜3 文) を追加
   - 中規模の場合は新しい小節 `### N.X 機能名` を節末尾に追加
4. YAML フロントマターの `last_updated` を今日の日付に更新

**編集は `str_replace` または `Edit` ツールで行う**。既存の段落の途中に割り込むのではなく、節末尾の空行直前に追加することで最小 diff を保つ。

### ステップ 6: タイムラインを更新する

`guide/appendix-a-timeline.md` の表に **1 行追加** する:

```markdown
| YYYY/MM/DD | **機能名** (vX.Y.Z): 一言説明 |
```

- 日付は**リリース日**を使う (CHANGELOG に記載)
- バージョンは太字で
- 説明は 30 文字以内

### ステップ 7: 破壊的変更があれば README を更新

🔴 Breaking が 1 件でもある場合:

- `README.md` の冒頭付近に `## ⚠️ 今週の重要な変更` セクションを設置/更新
- 該当週のエントリを追加

### ステップ 8: 週次サマリを作成

`state/weekly-summaries/YYYY-Www.md` を新規作成。週番号 (ISO 8601) は以下で取得:

```bash
date +%G-W%V
```

テンプレートは `.claude/CLAUDE.md` の「サマリのテンプレート」セクションに記載されている形式に従う。

### ステップ 9: 状態を更新する

1. `state/last-changelog-sha.txt` を **今日最新の CHANGELOG コミット SHA** に更新
   - `/tmp/changelog-diff.md` の冒頭にメタ情報として記載されている
2. `state/last-changelog-version.txt` を **今週反映した最新バージョン** に更新
3. `state/last-blog-urls.json` に **今週処理したブログ URL を追加**

### ステップ 10: PR 用コミットメッセージをファイルに書き出す

次のワークフローステップで PR タイトル/説明として使う内容を `/tmp/pr-description.md` に出力:

```markdown
# Weekly Update: YYYY-Www

## 概要
- CHANGELOG: vX.Y.Z → vA.B.C (N リリース)
- 新着ブログ: M 本
- ガイドへの反映: N 章

## 🔴 Breaking
(あれば列挙 / なければ "なし")

## 🟠 Major
- ...

## 🟡 Minor
- ...

## 📝 ブログ
- [タイトル](URL)

## 📖 変更ファイル
- `guide/NN-xxx.md`: 説明
- `state/weekly-summaries/YYYY-Www.md`: 新規作成
- `state/last-*.txt`, `state/last-*.json`: 状態更新

---
レビューポイント:
- [ ] 機能名・バージョンが正しいか
- [ ] 反映先の章が適切か
- [ ] 破壊的変更の判定が正しいか
```

## 実行完了の合図

すべて完了したら、以下を一文で報告:

```
週次更新完了: YYYY-Www (CHANGELOG N件 + ブログ M本を反映、guide 内 K ファイルを更新)
```

## 詳細なサブフロー

より細かい処理は以下の Skill を参照:
- `@.claude/skills/reflect-changelog/SKILL.md` — CHANGELOG 反映の詳細
- `@.claude/skills/reflect-blog/SKILL.md` — ブログ反映の詳細
