---
name: reflect-changelog
description: Reflect Claude Code CHANGELOG entries into the Japanese guide. Used as a sub-step by weekly-update.
---

# CHANGELOG 反映サブフロー

このスキルは CHANGELOG の差分を**1 エントリずつ**ガイドに反映する処理を担う。`weekly-update` から呼ばれる。

## 入力

- `/tmp/changelog-diff.md` — 前回以降の CHANGELOG 変更点

形式例:
```
## 2.1.112 (April 18, 2026)

- Added /foo command for ...
- Fixed bug in ...
- Changed default behavior of /bar (BREAKING)

## 2.1.111 (April 16, 2026)

- Claude Opus 4.7 xhigh is now available! ...
- Auto mode is now available for Max subscribers
```

## 処理手順

### 1. エントリを分解

各 `## X.Y.Z (日付)` セクションを 1 リリースとして分離。箇条書きを 1 変更単位とする。

### 2. 各変更を分類

以下のキーワードで自動分類:

| パターン | 分類 | 処理方針 |
|---|---|---|
| `BREAKING`, `Removed`, `Deprecated` | 🔴 Breaking | README 警告 + 該当章書き換え |
| `Added /xxxコマンド` | 🟠 Major | 11 章と付録 B に追加 |
| `Added new <機能>`, `GA`, `released` | 🟠 Major | 該当章に節追加 |
| `Now available in ...` | 🟠 Major | 該当章の該当箇所に追記 |
| `Improved`, `Faster`, `Better` | 🟡 Minor | 該当章に 1 文追記または無視 |
| `Fixed ...`, `Resolved ...` | 🔵 Patch | weekly-summary のみ |
| `Updated docs`, `Internal`, `Refactored` | ⚪ Irrelevant | 記録しない |

判定に迷ったら **🟠 Major** とする (保守的に)。

### 3. 反映先マッピング (詳細表)

| 変更内容 | 反映先 | 追記方法 |
|---|---|---|
| 新モデル (`Claude Opus X.Y`) | `guide/02-setup.md` §1.3 の表に行追加 | テーブル行 |
| モデルの挙動変更 | `guide/02-setup.md` §1.3 末尾に 1 段落 | 段落 |
| `/effort` の新レベル | `guide/02-setup.md` §1.3 + `guide/appendix-b-commands.md` | 両方 |
| 新スラッシュコマンド `/xxx` | `guide/11-keybindings-cheatsheet.md` の該当表に行追加 + `guide/appendix-b-commands.md` | テーブル行 + コマンド早見表 |
| 新キーバインド | `guide/11-keybindings-cheatsheet.md` §10.1 表に行 | テーブル行 |
| Skills 関連 | `guide/06-extension-mechanisms.md` §5.2 | 段落 or 表 |
| Subagents 関連 | `guide/06-extension-mechanisms.md` §5.3 | 段落 |
| Agent Teams 関連 | `guide/06-extension-mechanisms.md` §5.5 | 段落 |
| Hooks (新イベント) | `guide/06-extension-mechanisms.md` §5.4 の 12 イベント表 | テーブル行 |
| MCP 関連 | `guide/06-extension-mechanisms.md` §5.6 | 段落 |
| Plugin Marketplace | `guide/07-plugin-marketplace.md` | 段落 or 表 |
| Permission / Auto Mode | `guide/05-auto-mode-computer-use.md` §4.1 | 段落 |
| Computer Use | `guide/05-auto-mode-computer-use.md` §4.2 | 段落 |
| Sandboxing | `guide/05-auto-mode-computer-use.md` §4.3 | 段落 |
| SDK (`--bare`, `setting_sources`, etc.) | `guide/09-agent-sdk.md` §8.2 | 段落 |
| Python SDK 機能 | `guide/09-agent-sdk.md` §8.3 | 段落 |
| TypeScript SDK 機能 | `guide/09-agent-sdk.md` §8.4 | 段落 |
| Managed Agents | `guide/09-agent-sdk.md` §8.6 | 段落 |
| Worktree 機能 | `guide/10-parallel-execution.md` §9.1 | 段落 |
| `/schedule`, Scheduled Tasks | `guide/10-parallel-execution.md` §9.5 | 段落 |
| `/remote-control`, Remote Control | `guide/10-parallel-execution.md` §9.6 | 段落 |
| `/branch`, `--fork-session` | `guide/10-parallel-execution.md` §9.3 | 段落 |
| `/rewind` | `guide/10-parallel-execution.md` §9.7 | 段落 |
| Voice モード | `guide/02-setup.md` §1.5 | 段落 |
| IDE 拡張 (VS Code, JetBrains) | `guide/02-setup.md` §1.1 または新節 | 段落 |
| インストーラ変更 | `guide/02-setup.md` §1.1 | コードブロック差し替え |
| GitHub Actions 統合 | `guide/08-team-context.md` | 段落 |
| Analytics API, Enterprise | `guide/08-team-context.md` §7.6 | 段落 |

### 4. 最小 diff ルール

- **既存の段落の中を書き換えない**
- 追記は節または表の末尾
- 表に行を追加する場合、**既存の並び順** (アルファベット順、リリース順など) を維持
- 既に書かれている事実と矛盾する場合は、その旨を PR 説明で明記

### 5. 反映時のテンプレート

#### テーブル行追加の例

```markdown
<!-- 既存の表 -->
| `/effort` | Opus 4.7 の深さ調整 (low/medium/high/xhigh/max) |

<!-- 追加 -->
| `/effort` | Opus 4.7 の深さ調整 (low/medium/high/xhigh/max) |
| `/foo`    | 新機能の一言説明 |
```

#### 段落追加の例

```markdown
<!-- 既存節 -->
### 4.7 Rewind

(既存の説明...)

<!-- ここに追加 -->

#### 2026-04-18 追記 (v2.1.112)

Rewind は checkpoint スナップショットを保持するようになり、複数段階前への巻き戻しが可能になった。詳細は [公式ドキュメント](https://code.claude.com/docs/ja/rewind) を参照。
```

節末の `<!-- 既存内容の終わり -->` のような明確な境界があれば、その直前に追加する。

### 6. リリースをまとめる場合

複数リリースで同じ機能が段階的に出ている場合 (例: v2.1.109 で実験的に登場、v2.1.112 で GA) は、**最新のリリース 1 つをタイムスタンプに使い、途中経緯を 1 段落で要約する**:

```markdown
#### 2026-04-18 GA (v2.1.112)

v2.1.109 で実験導入されていた `/foo` が、v2.1.112 で GA となった。
```

### 7. 処理しないもの

以下は **CHANGELOG に載っていてもガイドには反映しない**:

- Windows/Mac/Linux 固有のバグ修正
- ターミナルの表示ちらつき修正
- CI/CD 内部変更
- `/debug` などの開発者向け内部コマンド調整
- IDE 拡張の軽微な UI 変更
- **ただし weekly-summary にはすべて記録する** (Patch として)

## 出力

- 編集された `guide/NN-*.md` ファイル群
- 更新された `guide/appendix-a-timeline.md`
- 必要なら更新された `README.md`
