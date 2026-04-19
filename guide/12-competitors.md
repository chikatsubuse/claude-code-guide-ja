---
title: "11. 競合ツールとの使い分け"
last_updated: 2026-04-17
chapter_id: 12-competitors
---

## 11. 競合ツールとの使い分け

**これは 2025 年の講演には存在しなかった視点** です。2026 年の開発者は、Claude Code 単体ではなく**複数の AI エージェントを組み合わせる** のが普通になっています。

### 11.1 主要 3 強の位置付け (2026 年 4 月時点)

| ツール | 強み | 弱み | 料金感 |
|---|---|---|---|
| **Claude Code** | 最深の推論 / 多ファイル編集 / 成熟した拡張エコシステム | Anthropic モデル限定 | Pro $20, Max $100〜200/月 |
| **OpenAI Codex CLI** | Rust 実装で高速 / オープンソース (Apache 2.0) / ChatGPT Plus に含まれる | Multi-file 推論は Claude に劣る | ChatGPT Plus に内包 / API 従量 |
| **Google Gemini CLI** | 1M context / 無料枠 1000 req/day / Google Search grounding | 複雑推論で不安定、長時間セッションで一貫性低下 | 無料 (Flash) / Pro 有料 |

### 11.2 ベンチマーク比較 (2026 年独立テスト)

複雑な多ファイルタスクでの first-pass 正答率 (Particula Tech 測定):

- Claude Code: **約 92%** (Opus 4.6 / SWE-bench Verified 80.9%)
- Gemini CLI: 85〜88%
- Codex CLI: 単一ファイル・サンドボックスでは高速、Terminal Bench では 19 位 (Claude Code は 3 位)

### 11.3 2026 年の新定番: 併用ワークフロー

**「2つのフロンティアモデルを協働させる」** のが 2026 年のベストプラクティスとして定着しました。

#### パターン: Claude Code + Codex CLI

```bash
# 1. Codex CLI もインストール
npm install -g @openai/codex
export OPENAI_API_KEY=sk-...

# 2. Claude Code の CLAUDE.md に記載
# 「並列で作業を進めたい場合、または第二の意見が欲しい場合は、
#  Bash で以下を実行して Codex を呼び出せる:
#  codex exec '<task description>'」
```

Claude Code が**計画とコーディネート**、Codex が**スコープの明確な実装タスク** (例: "rewrite this file to use React Server Components") を並列サブシェルで実行 — という分業が効率的です。

#### Claude Code を選ぶべき場面

- **複雑な多ファイルリファクタリング**
- **長時間の自律エージェント作業** (Scheduled Tasks + Auto Mode)
- **チーム開発で共有される基盤を作りたい** (拡張エコシステムが最成熟)
- **エンタープライズ要件** (Bedrock/Vertex/Managed Agents/Analytics API)

#### 他ツールを選ぶべき場面

- **モノレポ全体を一度に見たい** → Gemini CLI (1M context)
- **既に ChatGPT Plus ユーザ / OSS が欲しい** → Codex CLI
- **簡易タスク・予算重視** → Gemini CLI (無料枠)

### 11.4 "The Model is Not the Agent" — 足回りで勝負が決まる

2026 年の重要な学び: **モデル単体の性能より、エージェントの足回り (scaffold) が結果を左右します**。

SWE-bench Pro では、**同じ Opus 4.5 を使っても scaffold の違いで 22 ポイント近い差** が出ました。実際、同じ Opus 4.5 を使っているにも関わらず Augment の Auggie は Claude Code より 17 問多く解いています (731問中)。

**Claude Code の足回りが優れている理由**:
- 練り込まれた tool definitions と TodoWrite の活用
- Skills/Subagents による自動的なコンテキスト最適化
- Hooks による検証ループの組み込み
- MCP のツール遅延ロード

これが、元講演で Boris 氏が「**Claude Code も、Claude Code が使う SDK も同じもの**」と強調した設計思想の価値です。

---
