# Weekly Update: 2026-W16 (後半)

## 概要
- CHANGELOG: v2.1.111 → v2.1.114 (3 リリース: 2.1.112, 2.1.113, 2.1.114)
- 新着ブログ: 0 本
- ガイドへの反映: 4 ファイル (guide 3 章 + appendix-a)

## 🔴 Breaking

なし

## 🟠 Major

- **CLI ネイティブバイナリ化** (v2.1.113): CLI がプラットフォームごとのネイティブバイナリを起動するアーキテクチャに変更。従来の JavaScript バンドル実行方式より起動速度・メモリ効率が向上。`guide/02-setup.md` §1.1 に追記。

## 🟡 Minor

- **`sandbox.network.deniedDomains`** (v2.1.113): `allowedDomains` ワイルドカードで許可されたドメインのうち特定ドメインだけをブロックする新設定。`guide/05-auto-mode-computer-use.md` §4.3 に設定例を追加。
- **`Ctrl+A`/`Ctrl+E` キーバインド** (v2.1.113): 複数行入力で論理行の行頭/行末に移動 (readline 互換)。`guide/11-keybindings-cheatsheet.md` §10.1 に追加。

## 🔵 Patch (ガイド反映なし)

- v2.1.114: エージェントチームのパーミッションダイアログのクラッシュ修正
- v2.1.113: セキュリティ強化多数 (macOS 危険パス判定、Bash deny ルールの exec ラッパー対応、`find -exec` 自動承認廃止)
- v2.1.113: MCP 同時呼び出しのウォッチドッグタイムアウト修正
- v2.1.112: Opus 4.7 "temporarily unavailable" エラー修正

## 📝 ブログ

新着なし (既知: 6 本)

## 📖 変更ファイル

- `guide/02-setup.md`: §1.1 末尾にネイティブバイナリ化の説明を追記
- `guide/05-auto-mode-computer-use.md`: §4.3 末尾に `deniedDomains` 設定例を追記
- `guide/11-keybindings-cheatsheet.md`: §10.1 表に `Ctrl+A`/`Ctrl+E` 行を追加
- `guide/appendix-a-timeline.md`: v2.1.113 のネイティブバイナリ化エントリを追加
- `state/weekly-summaries/2026-W16.md`: 週次サマリを更新
- `state/last-changelog-sha.txt`: `HEAD~20` → `0385848b4e737831fc3b973d9a78d31950a87d9d`
- `state/last-changelog-version.txt`: `2.1.111` → `2.1.114`
- `state/last-blog-urls.json`: `last_checked` 日付を更新

---
レビューポイント:
- [ ] CLI ネイティブバイナリ化を 🟠 Major と判定したが、ユーザー影響は透過的 (自動で切り替わる)。🟡 Minor への格下げが適切か確認してください
- [ ] `sandbox.network.deniedDomains` の設定例 JSON は公式ドキュメントが整備され次第、リンクを追記することを推奨
- [ ] v2.1.113 のセキュリティ強化 (Bash 権限周り) は詳細が多く、`guide/05-auto-mode-computer-use.md` や `guide/08-team-context.md` への追記が有益かもしれない (今回は Patch 扱いでスキップ)
