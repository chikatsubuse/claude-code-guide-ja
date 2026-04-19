---
title: "3. 編集・ツール・ワークフロー"
last_updated: 2026-04-17
chapter_id: 04-editing-tools
---

## 3. 編集・ツール・ワークフロー

Q&A に慣れたら、いよいよ編集・実装へ進みます。ここは講演の **Tip #2, #3, #4** に相当する、ツール活用の領域です。

### 3.1 組み込みツールの 2026 年版

Boris 氏が紹介した 12 種類の組み込みツールは、2026 年にはさらに強化・追加されています。

**講演当時から存在するもの**:
- bash (シェル実行)
- file search / file listing / file read / file write
- web fetch / web search
- TODOs (TodoWrite ツール)
- sub-agents (Agent ツール)

**2026 年に新規追加または大幅強化**:
- **Skill ツール** — `/init`, `/review`, `/security-review` などの内蔵コマンドを、Claude が自律的に判断して起動
- **Computer Use** — スクリーンショット経由の GUI 操作 (4 章で詳述)
- **Schedule** — `/schedule` でクラウド実行 (9 章で詳述)
- **Notebook 編集** — Jupyter ノートブックの対話的編集
- **Tool Search** — MCP ツールの遅延ロード (コンテキスト削減率最大 95%)

### 3.2 Tip #3: チームのツールを教える — MCP 時代

元講演時点で MCP は始まったばかりでしたが、**2026 年 4 月時点で MCP エコシステムは爆発的に拡大**。50+ の人気 MCP サーバーがあり、プラグインマーケットプレイスには公式・コミュニティ製合わせて 2,500 以上のサーバーが登録されています。

**MCP サーバーの追加** (講演時と同じ):

```bash
claude mcp add barley_server -- node myserver
```

**実際によく使われる MCP サーバー** (2026 年版):

| カテゴリ | 代表 MCP サーバー | 用途 |
|---|---|---|
| GitHub | `github` (公式) | Issue/PR 管理、コード検索 |
| ブラウザ | `playwright` (Microsoft 公式) | E2E テスト、スクリーンショット |
| データベース | `postgres` / `supabase` | 自然言語クエリ |
| ドキュメント | `context7` (Upstash) | ライブラリの最新ドキュメント取得 |
| チャット | `slack` (公式) / `discord` | メッセージ投稿、コンテキスト取込 |
| モノリポ | `jira-confluence` | スプリント/仕様書連携 |
| セキュリティ | `semgrep` | リアルタイム脆弱性検出 |

**重要な新機能 — Tool Search**:

MCP サーバーを複数追加するとコンテキストを圧迫していましたが、2026 年は **MCP Tool Search** によりツールが遅延ロードされ、Claude が必要に応じて検索して呼び出す仕組みになりました。MCP 追加のコストが大きく下がっています。

### 3.3 Tip #4: タスクごとのワークフロー

講演で示された 4 つのプロンプトパターンは 2026 年も有効です。加えて新しいパターンが追加されました。

#### パターン 1: 提案 → 選択 → 実装

```
Propose a few fixes for issue #8732, then implement the one I pick
```

#### パターン 2: 拡張思考 + xhigh effort

```
Identify edge cases not covered in @app/tests/signupTest.ts,
then update the tests to cover these, think hard
```

**2026 年拡張**: `/effort xhigh` と組み合わせると Opus 4.7 の深い推論が引き出せる。

#### パターン 3: 短縮形プロンプト

```
commit, push, pr
```

#### パターン 4: 並列サブエージェント

```
Use 3 parallel agents to brainstorm ideas for how to clean up
@services/aggregator/feed_service.cpp
```

#### ★ パターン 5 (2026 年新規): Plan Mode

```
/plan Implement user notifications system
```

または、起動時に `--plan` オプション。**書き込み前に、必ず設計書を出力して承認を求める** 読み取り専用モード。AI エージェントの典型的失敗 (「理解する前に書き始める」) を防ぐために、2026 年に定着した運用パターンです。Gemini CLI が先駆けて実装し、Claude Code も類似のアプローチ (`Plan` subagent と explicit 計画プロンプト) を採用しています。

#### ★ パターン 6 (2026 年新規): Rewind

作業中に「大きく間違えた」と気付いたら `/rewind` で会話とコード変更をまとめてアンドゥできます。Esc Esc の強化版。

### 3.4 フィードバックループ — 講演の教えは今も王道

Boris 氏の最重要メッセージ: **「検証手段を渡して反復させよ」** は 2026 年も健在です。むしろ、2026 年の Hooks (5 章で詳述) により、この反復を**自動化できるようになりました**。

**古典的なフィードバックループの例**:
- ユニットテスト → 失敗したら修正 → 再実行
- Puppeteer でスクリーンショット → 見た目の差分 → 修正
- Lint → エラー箇所を修正

**2026 年: Hooks による自動化** (詳細は 5.4 章):

```json
// ~/.claude/settings.json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{ "type": "command", "command": "npm test --bail 2>&1 | tail -20" }]
    }]
  }
}
```

これで Claude がファイルを編集するたびに自動でテストが走り、結果が次のターンのコンテキストに戻されます。「Claude が anticipatory (先回り) になる」と報告されている挙動で、元講演のフィードバックループ思想の完成形です。

---
