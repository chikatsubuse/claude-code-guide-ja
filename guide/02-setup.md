---
title: "1. インストール・モデル選択・セットアップ"
last_updated: 2026-04-27
chapter_id: 02-setup
---

## 1. インストール・モデル選択・セットアップ

### 1.1 インストール

```bash
# 推奨: ネイティブインストーラ
curl -fsSL https://claude.ai/install.sh | bash

# 従来どおり npm でも可
npm install -g @anthropic-ai/claude-code
```

macOS / Linux はネイティブ、Windows は WSL2 または新しい PowerShell サポート経由で動作します。Homebrew (`brew install claude-code`) からもインストール可能です。

v2.1.113 以降、CLI はプラットフォームごとのオプション依存としてパッケージされた**ネイティブバイナリ**を起動するようになった (従来は JavaScript バンドルを Node.js で実行する方式)。起動速度とメモリ効率が向上する。

### 1.2 認証

- **個人**: `/login` で claude.ai の Pro ($20/月) または Max ($100〜$200/月) プランにサインイン
- **API キー**: `ANTHROPIC_API_KEY` 環境変数 (従量課金)
- **エンタープライズ**: AWS Bedrock (`CLAUDE_CODE_USE_BEDROCK=1`) / Google Vertex (`CLAUDE_CODE_USE_VERTEX=1`) へのバックエンド切替が可能

### 1.3 モデル選択 — 2026 年版

2026 年 4 月時点で、Claude Code が使える主要モデルは 3 つ (講演当時は 1 世代しかなかった部分が大きく変化)。

| モデル | 用途 | 特徴 |
|---|---|---|
| **Claude Opus 4.7** | 最重要タスク・長時間の自律作業 | 最強の推論性能。`xhigh` effort level 対応 |
| **Claude Sonnet 4.6** | 日常のほぼ全タスク | 速度と知能のバランス。**1M token context** ベータ |
| **Claude Haiku 4.5** | 超高速・低コスト | Sonnet 4 相当のコーディング性能。Chrome 拡張のデフォルト |

**モデル切り替え**:

```bash
/model                    # 対話的に選ぶ
claude --model opus-4-7   # 起動時に指定
```

**Effort level** (Opus 4.7 の深さ調整):

```bash
/effort                   # 対話スライダーで low / medium / high / xhigh / max
```

`xhigh` は 2026/4/16 に登場した新レベルで、`high` と `max` の間に位置します。複雑なリファクタリングや長時間の自律タスクで効果を発揮します。

v2.1.117 より、Pro/Max プランの Opus 4.6・Sonnet 4.6 のデフォルト effort が `medium` から `high` に変更された ([CHANGELOG](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md#2-1-117))。

### 1.4 起動直後の初期設定 — 2026 年版

講演当時の 6 項目に、この 1 年で登場した設定を加えた最新チェックリストです。

| 項目 | コマンド | 効果 |
|---|---|---|
| ターミナル改行 | `/terminal-setup` | Shift+Enter で改行 |
| テーマ | `/theme` | ライト/ダーク/Auto (ターミナル追従)。v2.1.118 以降は名前付きカスタムテーマの作成・切替も可能 |
| GitHub 連携 | `/install-github-app` | Issue/PR で `@claude` メンション |
| 通知 | `/config` → Notifications ON | 長時間タスクの完了通知 |
| **Voice モード** | `/config` → Voice ON | 喋って指示 (20 言語対応) |
| **Auto Mode** | `/config` → Auto Mode ON | 承認プロンプトを AI 分類器で自動化 |
| **Remote Control** | `/remote-control` | スマホ/Web から同じセッションに接続 |
| **Output style** | `/config` → output style | Explanatory / Learning など教育モード |
| 許可ツール | `/permissions` (旧 `/allowed-tools`) | ツール承認ルールをカスタマイズ |
| Fullscreen | `/tui fullscreen` | ちらつきのない全画面レンダリング |

### 1.5 音声入力 — Dictation からネイティブへ

元講演では macOS の Dictation を 2 回押す運用が紹介されていましたが、**2026 年では Claude Code ネイティブの Voice モード** が実装され、Claude Code チーム自身が「タイピングよりも喋る方が 3 倍速く、プロンプトも詳細になる」として、コーディングのほとんどを音声で行っているといいます。対応言語は 20 言語 (日本語・英語を含む)。

### 1.6 Sandboxing — より安全な実行

2026 年の Claude Code には **sandboxing** が組み込まれました。Linux では PID namespace isolation、Windows/macOS でも credentials scrubbing (環境変数からの認証情報除去) が標準化され、`--dangerously-skip-permissions` に頼らずに済むケースが増えました。Auto Mode と組み合わせると、**「承認地獄」を抜け出しつつ安全** という運用が可能になります (詳細は 4 章)。

---
