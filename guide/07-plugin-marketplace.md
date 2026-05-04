---
title: "6. Plugin Marketplace と Skills 活用"
last_updated: 2026-05-04
chapter_id: 07-plugin-marketplace
---

## 6. Plugin Marketplace と Skills 活用

**2025 年 11 月に Anthropic が発表した Plugin システム** は、拡張機構の「配布」問題を解決しました。個人が作った Skills/Subagents/Hooks/MCP を、1 コマンドでインストール可能にしたものです。

### 6.1 Plugin とは

Plugin は **Skills, Subagents, Slash Commands, Hooks, MCP Servers** を束ねて配布するパッケージです。複雑な設定を 1 コマンドで全員に行き渡らせられます。

### 6.2 公式 Marketplace の使い方

Claude Code は起動時に **Anthropic 公式 Marketplace (`claude-plugins-official`)** に自動接続します。

```bash
/plugin                        # マーケットプレイス UI を開く
/plugin install github@claude-plugins-official
/plugin install playwright@claude-plugins-official
```

`/plugin` を開くと 4 タブ:
- **Discover** — 登録済み Marketplace から探す
- **Installed** — インストール済みの管理 (Enable/Disable/Uninstall)
- **Marketplaces** — Marketplace の追加/削除
- **Errors** — ロードエラーの確認

孤立した依存関係 (他のプラグインが削除されて不要になった自動インストール済みパッケージ) を一括削除するには `claude plugin prune` を使う (v2.1.121 〜)。`plugin uninstall <name> --prune` でアンインストールと同時に依存の連鎖削除も可能。

### 6.3 サードパーティ Marketplace

公式以外の Marketplace も追加できます。

```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

公開されている主要な Marketplace:

| Marketplace | 特徴 |
|---|---|
| `claude-plugins-official` | Anthropic 公式。GitHub, Playwright, Supabase など |
| `superpowers` | 完全な agentic 開発ワークフロー (brainstorm → design → plan → execution → review) |
| `awesome-claude-plugins` (Composio) | キュレーションされたプラグイン集 |
| `oh-my-claudecode` | oh-my-zsh 風のプラグインフレームワーク |

### 6.4 Superpowers — 2026 年最も普及したプラグイン

**obra/superpowers-marketplace** は、Claude Code の開発哲学を集約した代表的プラグインです。

```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

同梱される主要 Skill:
- **brainstorming** — Socratic な問いかけでアイデアを精錬、設計書として保存
- **using-git-worktrees** — 承認後に隔離ブランチを作り、テストが通る状態を確認してから実装開始
- **writing-plans** — 承認済み設計を 2〜5 分の単位タスクに分割 (正確なファイルパス・コード・検証手順付き)
- **subagent-execution** — 計画を並列サブエージェントに割り振り
- **review-cycle** — Codex/RepoPrompt 等との多モデルレビューゲート

これは **Boris 氏の講演の最重要教義「検証手段を与えて反復させよ」の完成版** と言えます。

### 6.5 自作 Skill の書き方

個人のワークフローを Skill 化するには、3 要素だけ必要です。

```markdown
---
name: release-pr
description: Create a release PR with changelog and version bump. Use when the user asks to cut a release.
---

Create a release PR:
1. Determine the next version number from git tags
2. Update package.json / Cargo.toml / pyproject.toml version
3. Generate CHANGELOG.md entries from merged PRs since last tag
4. Create branch `release/v$VERSION`, commit, push, and open PR
5. Tag the PR with "release" label

If any step fails, stop and ask for guidance.
```

**保存**: `~/.claude/skills/release-pr/SKILL.md` (個人用) または `.claude/skills/release-pr/SKILL.md` (プロジェクト共有)

**呼び出し**:
- 明示: `/release-pr` または `@release-pr`
- 自動: Claude が description に基づいて発動

### 6.6 Plugin 作成とマーケットプレイス公開

自作 Plugin を公開するには、`.claude-plugin/marketplace.json` を持つ GitHub レポを用意するだけ。

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json         ← カタログ
└── plugins/
    └── my-plugin/
        ├── plugin.json          ← マニフェスト
        ├── skills/
        │   └── my-skill/SKILL.md
        ├── agents/
        │   └── my-agent.md
        └── hooks/
            └── post-edit-test.sh
```

公開したら:

```bash
/plugin marketplace add <github-username>/<repo>
```

でインストール可能になります。

### 6.7 Enterprise 向け: 社内専用マーケットプレイス

エンタープライズでは、公開 Marketplace を使わずに **プライベート GitHub レポを Marketplace として配布** できます。

```bash
/plugin marketplace add private-github.example.com/company/internal-plugins
```

管理者は特定チームへの auto-install やアクセス制御を設定可能。これは Cowork で 2026 年 2 月に導入された機能で、社内ツール統合の大きな障壁を取り除きました。

---
