---
title: "2. コードベース Q&A から始める"
last_updated: 2026-04-17
chapter_id: 03-codebase-qa
---

## 2. コードベース Q&A から始める

> *"The easiest way for new users to start with Code. Zero setup needed. Your data stays local."*
> — Boris Cherny, 2025

**この原則は 2026 年も変わりません。** むしろ、Claude Code が複雑化した今だからこそ、**最初の 1 時間は編集もツールも触らず、ただ質問するだけ** で始めるのが最短ルートです。

### 2.1 なぜ Q&A から始めるのか (再確認)

- **編集させない**から壊れない
- **ゼロセットアップ** — インデックス作成も事前アップロードもなし
- **ローカル完結** — コードは端末から出ず、モデル学習にも使われない
- プロンプト感覚と、Claude Code の得意・不得意を自然に学べる

Anthropic 社内では、技術系新入社員のオンボーディングで Claude Code に質問攻めをさせる運用が定着し、**オンボーディング期間が 2〜3 週間から 2〜3 日に短縮** されたと報告されています。

### 2.2 プロンプト例 — 講演時のレシピはそのまま使える

元講演で紹介された 7 つのプロンプト例は、2026 年の Opus 4.7 / Sonnet 4.6 でもそのまま、かつより高い精度で動作します。

```
How is @RoutingController.py used?
```
→ 呼び出し箇所と使用パターンを一段深く探索

```
Why does recoverFromException take so many arguments? Look through git history to answer
```
→ **Git 履歴を遡って引数追加の経緯を要約** (関連イシューまで追跡)

```
What did I ship last week?
```
→ Git ログからユーザー名で絞り込み、今週マージした内容を整形

**@ メンション**: `@path/to/file.py` でファイル/フォルダをコンテキストに投入。

### 2.3 2026 年ならではの Q&A 拡張

**拡張思考キーワード** (`think`, `think hard`, `think harder`, `ultrathink`):

```
Think hard about why this authentication flow is slow under load.
```

2026 年では **`/effort xhigh`** スイッチと組み合わせることで、さらに深い分析が引き出せます。Opus 4.7 の長時間推論と相性が良いです。

**並列サブエージェント** (元講演で紹介されたが、2026 年は自作も可能に):

```
Use 3 parallel agents to explore different angles of how the payment module handles refunds.
```

**1M token context** (Opus 4.6 以降):

```
Read all files under @src/ and @tests/ and give me an architecture overview.
```

モノレポ全体を一度にロードできるようになったので、「ファイル選別」のステップ自体が不要になるケースが増えました。

### 2.4 チーム導入のコツ — 2025 年と同じ

新メンバーには **必ず Q&A から始めさせる**。いきなり編集タスクを振ると「壊れてから教育される」悪循環に陥ります。最初の半日は「質問だけ」を徹底すると、2 日目以降の学習速度が劇的に上がります。

---
