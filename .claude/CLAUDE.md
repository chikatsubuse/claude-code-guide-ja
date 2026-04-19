# CLAUDE.md — 入門ガイド編集の憲法

このリポジトリは **Claude Code 入門ガイド (日本語版)** を週次で最新化する場所です。
Claude Code 自身がこのファイルを読んでガイドを編集するため、以下のルールを厳守してください。

## 📐 文体ルール

- **「です・ます」調ではなく「である」調・常体** で書く
- 一人称は使わない (「筆者は」「私は」を避ける)
- 文末は簡潔に (「〜できます。」→「〜できる。」)
- **技術用語は英語のまま** 使うことも多い (例: "CLAUDE.md", "hooks", "subagents")
- 英語の引用はインラインコード `` ` `` で囲む

## 🏗 構造ルール

### 骨格は触らない

このガイドは **Boris Cherny 氏の「Mastering Claude Code in 30 minutes」 (2025/5/22)** を出発点とする 5 段階ロードマップで構成されている。

```
第1段階: Getting your feet wet    → Q&A (ch02, ch03)
第2段階: You are no longer a padawan → 編集・ツール (ch04, ch05)
第3段階: Extending Claude (新設)   → 拡張機構 (ch06, ch07)
第4段階: Scaling up                → チーム (ch08)
第5段階: Leveling up               → SDK・並列 (ch09, ch10)
```

**この 5 段階の骨格は絶対に変えない**。章の順序入れ替え、章の大規模な合併・分割もしない。

### 新機能の追加方針

- **小さな新機能** → 該当章の既存節の末尾に 1〜3 段落で追記
- **中規模の新機能** → 該当章に新しい節 (`### 4.7 新機能の名前` のような形式) を追加
- **大規模な新カテゴリ** → README に報告し、章新設の判断を人間レビューに任せる

### 破壊的変更

以下は**勝手にしない** (PR の説明欄で提案に留める):
- 章の削除
- 章番号の変更
- 章の順序の入れ替え
- 5 段階ロードマップの再定義

## 📄 ファイル操作ルール

### YAML フロントマター

各章ファイルは以下のフロントマターを持つ:

```yaml
---
title: "章タイトル"
last_updated: YYYY-MM-DD
chapter_id: NN-chapter-slug
---
```

**ファイルを編集したら必ず `last_updated` を今日の日付に更新する**。

### 編集の最小化

- **既存の段落を勝手に書き直さない** (事実誤認がある場合を除く)
- **削除は慎重に** — 情報の移動 or 書き換えを優先
- 変更は **最小限の diff** になるように

### コードブロックと表

- コードブロックは元のインデントを保つ
- 表の列幅を揃える
- 新しい項目は既存の並び順の論理に従って挿入 (アルファベット順、リリース順など)

## 🔗 参照方針

### 公式ドキュメントへのリンクを優先

ガイド本文では機能の詳細に深入りせず、**公式日本語ドキュメントへのリンクを貼る**。

```markdown
<!-- 良い例 -->
詳細は [公式ドキュメント](https://code.claude.com/docs/ja/hooks) を参照。

<!-- 悪い例 -->
詳細は [公式ドキュメント](https://code.claude.com/docs/en/hooks) を参照。
<!-- (日本語版があるときは日本語 URL を使う) -->
```

日本語版が存在しない場合は英語版リンクを貼り、そばに "(英語ドキュメント)" と明記する。

### 出典の明示

CHANGELOG や ブログから情報を取り込む場合は、可能な範囲で出典を記載する:

```markdown
<!-- 例 -->
2026 年 4 月の v2.1.111 で `/effort xhigh` が追加された
([CHANGELOG](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md#2-1-111))。
```

## 🚫 禁止事項

- ❌ 英語ドキュメントの機械翻訳をそのまま貼り付ける
- ❌ 出典不明の機能説明を加える
- ❌ プレビュー/ベータ機能を GA と書く
  - → `**(プレビュー)**` `**(ベータ)**` と明示する
- ❌ 価格情報を推測で書く (公式発表のみ採用)
- ❌ 他社製品 (OpenAI, Google) について根拠なき評価を加える

## ✅ 週次更新タスク

`@.claude/skills/weekly-update/SKILL.md` を実行する際は以下の順序で進める:

1. `state/last-changelog-sha.txt` と `state/last-blog-urls.json` を読む
2. `/tmp/changelog-diff.md` (前回以降の CHANGELOG 差分) を読む
3. `/tmp/new-blog-posts.json` (前回以降の新着ブログ) を読む
4. **重要度を判定** (下記基準参照)
5. 該当する章ファイルに最小 diff で追記
6. `guide/appendix-a-timeline.md` に 1 行追加
7. `state/weekly-summaries/YYYY-Www.md` にサマリ作成
8. `state/last-changelog-sha.txt` と `state/last-blog-urls.json` を更新

### 重要度判定基準

| レベル | 例 | ガイドへの反映 |
|---|---|---|
| **🔴 Breaking** | 既存コマンドの削除・リネーム、デフォルト挙動変更 | 該当章を修正 + README 冒頭に警告 |
| **🟠 Major** | 新モデル追加、新スラッシュコマンド、新拡張機構 | 該当章に節を追加 or 段落追記 |
| **🟡 Minor** | 既存機能の改善、新オプション追加 | 該当章に 1〜2 文追記、または表に追記 |
| **🔵 Patch** | バグ修正、パフォーマンス改善 | ガイドには反映せず weekly-summary のみ |
| **⚪ Irrelevant** | 内部リファクタ、CI 変更 | 記録しない |

### サマリのテンプレート

`state/weekly-summaries/YYYY-Www.md` は以下の形式で:

```markdown
---
week: YYYY-Www
period: YYYY-MM-DD 〜 YYYY-MM-DD
changelog_from: v2.1.XXX
changelog_to: v2.1.YYY
blog_posts: N
guide_changes: [ch02, ch06, appendix-a]
---

# 週次サマリ YYYY-Www

## 🔴 Breaking Changes
(なければ「なし」)

## 🟠 Major Updates
- **機能名** (vX.Y.Z): 説明...

## 🟡 Minor Updates
- ...

## 📝 公式ブログ
- [記事タイトル](URL) — 一言要約

## 📖 ガイドへの反映
- `guide/NN-xxx.md`: 何を追加したか
- `guide/appendix-a-timeline.md`: 追加行
```

## 🧠 判断に迷ったら

- **情報が曖昧** → ガイドには反映せず、weekly-summary に「要確認」として記録
- **章の所属が不明** → 最も近い章末に "**(暫定配置)**" と明記して追加
- **同じ機能が複数章で言及されうる** → メイン章 1 つだけに詳細を書き、他章ではリンクで参照
- **破壊的変更かどうか判断できない** → 🟠 Major 扱いにして PR で人間に問う

## 📚 関連ファイル

- `.claude/skills/weekly-update/SKILL.md` — メインの週次更新フロー
- `.claude/skills/reflect-changelog/SKILL.md` — CHANGELOG 反映の詳細
- `.claude/skills/reflect-blog/SKILL.md` — ブログ反映の詳細
- `scripts/` — データ取得の前処理スクリプト
- `guide/` — ガイド本体 (編集対象)
- `state/` — 処理状態 (更新対象)
