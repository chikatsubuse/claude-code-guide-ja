---
name: reflect-blog
description: Reflect new Claude blog posts into the Japanese guide. Used as a sub-step by weekly-update.
---

# ブログ記事反映サブフロー

このスキルは **claude.com/ja-jp/blog の新着記事** をガイドに反映する処理を担う。

## 入力

- `/tmp/new-blog-posts.json` — 新着ブログ記事情報

形式:
```json
[
  {
    "title": "記事タイトル",
    "url": "https://claude.com/ja-jp/blog/...",
    "date": "2026-04-15",
    "category": "コーディング"
  },
  ...
]
```

## 処理手順

### 1. 各記事を分類

| カテゴリ | 分類 | ガイドへの反映 |
|---|---|---|
| 製品発表 (新モデル、新 SKU) | 🟠 Major | 該当章 (通常 02-setup.md) に追記 |
| Claude Code 機能発表 | 🟠 Major | 該当章に追記 |
| Skills / Plugins 関連 | 🟡 Minor | `guide/06-extension-mechanisms.md` か `guide/07-plugin-marketplace.md` |
| 事例紹介・ケーススタディ | ⚪ Irrelevant | 反映せず weekly-summary に "参考リンク" として記載 |
| 戦略・ビジョン記事 | ⚪ Irrelevant | 反映せず weekly-summary に "参考リンク" |
| 採用・組織関連 | ⚪ Skip | weekly-summary にも記載しない |

**判断のルール**:
- 「新機能/新サービス/新モデル」というキーワードが含まれる → 本文反映
- 「活用法」「事例」「ビジョン」「未来」→ 参考リンクのみ

### 2. 記事本文を取得 (必要時)

🟠 Major と判定した記事は、実際に中身を確認する:

```
WebFetch: <URL>
```

取得した本文から:
- **公式発表の事実** (X が Y 可能になった、Z が GA になった)
- **リリース日**
- **対象プラン** (Pro/Max/Team/Enterprise)

を抜き出す。

### 3. 反映時のスタイル

ブログ記事は CHANGELOG より**文脈が豊か**なので、数字や背景を含めた 2〜4 文程度で反映する:

```markdown
#### 2026-04-15 公式ブログ

Anthropic 公式ブログによれば、XYZ 機能が全 Max プランで GA になった。
ベータ期間中のフィードバックを受けて、デフォルトの挙動が ABC に変更されている
([公式ブログ](https://claude.com/ja-jp/blog/xyz))。
```

### 4. 反映先マッピング

| ブログカテゴリ | 反映先 |
|---|---|
| 製品発表・アップデート | `guide/02-setup.md`, `guide/06-extension-mechanisms.md` 等該当章 |
| Claude Code 全般 | `guide/01-whats-changed.md` に 1 行追加 |
| Claude Code 事例 | 反映せず |
| エンタープライズ | `guide/08-team-context.md` に 1 段落 |
| Agent SDK | `guide/09-agent-sdk.md` |
| スキル・プラグイン | `guide/06-extension-mechanisms.md` / `guide/07-plugin-marketplace.md` |

### 5. 出典リンクは必ず**日本語 URL** を使う

```markdown
<!-- 良い -->
[公式ブログ](https://claude.com/ja-jp/blog/xxxx)

<!-- 悪い (日本語版があるのに英語 URL) -->
[Blog](https://claude.com/blog/xxxx)
```

日本語版が存在しないときのみ英語 URL を使い、「(英語記事)」と明記。

### 6. 既読 URL の記録

**処理した全記事** (Skip も含む) の URL を `state/last-blog-urls.json` に追加する。次回実行時に重複処理を避けるため。

JSON 形式:
```json
{
  "known_urls": [
    "https://claude.com/ja-jp/blog/how-enterprises-are-building-ai-agents-in-2026",
    "https://claude.com/ja-jp/blog/improving-frontend-design-through-skills",
    ...
  ],
  "last_checked": "2026-04-17T09:00:00Z"
}
```

## 出力

- 編集された `guide/NN-*.md` ファイル (🟠 Major のみ)
- 更新された `state/last-blog-urls.json`
- weekly-summary に「📝 公式ブログ」セクション用のリスト
