# state/ ディレクトリ

週次更新処理の状態を保持する。**このディレクトリは GitHub Actions が自動的に書き換える**ため、手動編集は基本的に不要。

## ファイル一覧

### `last-changelog-sha.txt`

前回処理した `anthropics/claude-code` の `CHANGELOG.md` コミット SHA を 1 行で記録する。

- 値は `40 桁の hex` または `HEAD~N` 形式
- 初回値: `HEAD~20` (初回実行時に「直近 20 コミット分」を取り込む)
- 以降は各週次実行の最後に最新 SHA で上書きされる

**手動で起点を変えたい場合**:
```bash
echo "abc123def456..." > state/last-changelog-sha.txt
```

### `last-changelog-version.txt`

最後に反映したセマンティックバージョンを 1 行で記録する (例: `2.1.111`)。

### `last-blog-urls.json`

claude.com/ja-jp/blog で既に処理した記事 URL の一覧。同じ記事を二重に反映しないため。

```json
{
  "known_urls": ["https://claude.com/ja-jp/blog/...", ...],
  "last_checked": "2026-04-17T00:00:00Z"
}
```

### `weekly-summaries/`

週ごとの処理サマリ (ISO 8601 週番号)。

- ファイル名形式: `YYYY-Www.md` (例: `2026-W17.md`)
- 中身は `🔴 Breaking / 🟠 Major / 🟡 Minor / 🔵 Patch / 📝 ブログ / 📖 ガイドへの反映`

## ファイルが壊れたとき

- `last-changelog-sha.txt` を消すと「初回状態」に戻り、`HEAD~20` 相当が起点となる
- `last-blog-urls.json` を消すと、blog 一覧ページに見える全記事を「新着」扱いする (大量の PR 噴出に注意)
- `weekly-summaries/` はデータソースではなくアウトプットなので、消しても次回以降に影響しない
