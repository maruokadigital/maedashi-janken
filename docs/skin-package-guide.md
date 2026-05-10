# スキンパッケージガイド

## 1. 概要

本ガイドは、前出しじゃんけんで利用するスキンパッケージの形式・構成・使い方を説明する。

スキンパッケージは ZIP ファイルとして配布し、ゲームの画像アセットを差し替えたり、フィールドの背景を設定したりすることができる。
スキンの設定はローカルのプレイヤーのみに影響し、対戦相手には反映されない。

設計上の原則：

- 画像のアスペクト比は維持される（比率を保ったスケーリングのみ）。
- 非均一な拡大・クロップは行わない。
- 画像と表示領域のアスペクト比が異なる場合、余白が生じることがある（これは仕様）。
- スキンは差分として適用される。指定していないスロットは変更されない。
- 背景は画像アセットスロットとは別に管理されるが、同じ manifest に含める。

---

## 2. パッケージ形式

スキンパッケージは ZIP ファイル（`.zip`）である。中に含めるもの：

- manifest ファイル（`manifest.json`、`manifest.txt`、または `skin.json`）
- manifest から参照される画像ファイル（省略可）
- manifest から参照される背景画像ファイル（省略可）

manifest がない場合、ファイル名の規則に基づいてアセットを自動検出しようとする。

---

## 3. ディレクトリ構成

推奨レイアウト：

```
my-skin.zip
├── manifest.json
├── hands/
│   ├── gu.png
│   ├── choki.png
│   └── pa.png
├── cards/
│   ├── frame.png
│   └── back.png
├── rules/
│   ├── icon/
│   │   ├── Icon_Hornet.png
│   │   └── ...
│   └── coin/
│       ├── Coin_Hornet.png
│       └── ...
└── backgrounds/
    ├── p1_field.png
    ├── p2_field.png
    ├── battlefield.png
    ├── scoreboard_main.png
    ├── scoreboard_lion.png
    ├── scoreboard_total.png
    ├── scoreboard_waiting_background.png
    ├── top_controls.png
    ├── footer.png
    ├── p1_hand.png
    ├── p1_icon.png
    ├── p1_message.png
    ├── p2_hand.png
    ├── p2_icon.png
    └── p2_message.png
```

ZIP 内のパスは読み込み時に小文字に正規化される。
非 ASCII 文字を含むパスは無視される。

---

## 4. manifest.json

manifest ファイルは JSON オブジェクトである。すべてのフィールドは省略可能。不明なフィールドは無視される。
`mappings` のスロットキーは大文字小文字を区別せず、内部で正規化される。

### 最小の valid な manifest

```json
{}
```

### 推奨フィールド

| フィールド | 型 | 説明 |
|---|---|---|
| `manifestVersion` | number | manifest フォーマットバージョン（`1` を使用） |
| `skinId` | string | 識別子（省略可、内部では使用しない） |
| `name` | string | スキンの表示名 |
| `author` | string | 作者名 |
| `description` | string | 説明文（省略可） |
| `mappings` | object | スロットとファイルパスの対応 |
| `display_groups` | object | 表示設定（手札シンボルのスケール設定など） |
| `backgrounds` | object | フィールドゾーンごとの背景設定 |

### mappings

`mappings` のキーはスロットキー、値は ZIP 内のファイルの相対パスである。

以下の場合、そのスロットは変更されない（「変更なし」として扱う）：

- キーが存在しない
- 値が空文字列
- 値が `null`
- 参照先ファイルが ZIP 内に存在しない

### display_groups.card_symbol

カード内の手札シンボルの表示方法を制御する。

```json
"display_groups": {
  "card_symbol": {
    "aspect_ratio": "1/1",
    "fit_scale_percent": 100
  }
}
```

| フィールド | 型 | 値 | 説明 |
|---|---|---|---|
| `aspect_ratio` | string | `"1/1"`, `"2/3"` | シンボル領域のアスペクト比 |
| `fit_scale_percent` | number | 10–200 | シンボル画像のスケール（%） |

---

## 5. アセット

### 5.1 手札シンボル

| スロット | 説明 |
|---|---|
| `hand.gu` | グー |
| `hand.choki` | チョキ |
| `hand.pa` | パー |

表示領域の比率：1:1
推奨サイズ：512×512 px（最小 256×256、最大 1024×1024）

### 5.2 カード

| スロット | 説明 |
|---|---|
| `card.frame` | カード表面フレーム |
| `card.back` | カード裏面 |

表示領域の比率：2:3（固定）
推奨サイズ：1024×1536 px（最小 512×768、最大 2048×3072）

### 5.3 ルールアイコン

スロットパターン：`rule.icon.<rulename>`

例：`rule.icon.Hornet`

通常ルール（コインあり）：

- Hornet, Rabbit, Elephant, Fox, Bear, Turtle, Crab, Peacock, Dolphin

通常ルール（アイコンのみ、コインなし）：

- Lion

特殊ルール（アイコンのみ）：

- Unknown, Alien, Zebra

表示領域の比率：1:1
推奨サイズ：512×512 px

### 5.4 ルールコイン

スロットパターン：`rule.coin.<rulename>`

コイン対応スロット：

- `rule.coin.Hornet`
- `rule.coin.Rabbit`
- `rule.coin.Elephant`
- `rule.coin.Fox`
- `rule.coin.Bear`
- `rule.coin.Turtle`
- `rule.coin.Crab`
- `rule.coin.Peacock`
- `rule.coin.Dolphin`

注意：`rule.coin.Lion` は存在しない。Lion にコインはない。

表示領域の比率：1:1
推奨サイズ：128×128 px（最小 64×64、最大 512×512）

### 5.5 ポイントアイコン

| スロット | 説明 |
|---|---|
| `point.-1` | ポイント値 -1 |
| `point.0` | ポイント値 0 |
| `point.1` | ポイント値 1 |
| `point.2` | ポイント値 2 |
| `point.lion_increase` | Lionフェーズ 増加ボタン |
| `point.lion_decrease` | Lionフェーズ 減少ボタン |

表示領域の比率：1:1
推奨サイズ：256×256 px
形式：PNG（透明背景推奨）

### 5.6 プレイヤーアイコン

位置ベーススロット（主要）：

| スロット | 説明 |
|---|---|
| `player.p1.human` | 上プレイヤー（人間） |
| `player.p1.cpu` | 上プレイヤー（CPU） |
| `player.p1.api` | 上プレイヤー（API） |
| `player.p1.remote` | 上プレイヤー（リモート） |
| `player.p2.human` | 下プレイヤー（人間） |
| `player.p2.cpu` | 下プレイヤー（CPU） |
| `player.p2.api` | 下プレイヤー（API） |
| `player.p2.remote` | 下プレイヤー（リモート） |

表示領域の比率：1:1
推奨サイズ：256×256 px

注意：スロットが設定されていない場合はデフォルトアイコンが表示される。代替画像への自動切り替えは行われない。

### 5.7 フェーズアイコン

| スロット | 説明 |
|---|---|
| `phase.exchange_intent` | 交換意思フェーズ |
| `phase.exchange_card_select` | 交換フェーズ（カード選択） |
| `phase.battle` | 勝負フェーズ |

表示領域の比率：1:1
推奨サイズ：256×256 px
形式：PNG（透明背景推奨）

### 5.8 勝利理由アイコン

| スロット | 説明 |
|---|---|
| `winreason.complete_point_dominance` | 完全支配 |
| `winreason.total_point_lead` | 合計ポイントリード |
| `winreason.by_last_win_fallback` | 最終勝利フォールバック |
| `winreason.by_rule_matched` | ルール一致 |
| `winreason.draw` | 引き分け |

表示領域の比率：1:1
推奨サイズ：256×256 px
形式：PNG（透明背景推奨）

注意：透明 PNG を使用すること。UIは明るい背景の上にこれらのアイコンを表示する。

### 5.9 UIアイコン

| スロット | 説明 |
|---|---|
| `ui.button.config` | 設定ボタン |
| `ui.button.description` | 説明ボタン |
| `ui.button.json` | JSON ボタン |
| `ui.button.skin` | スキンボタン |
| `ui.button.versus` | 対戦ボタン |
| `ui.button.statistics` | 統計ボタン |
| `ui.button.exit` | 終了ボタン |
| `ui.button.skip` | スキップボタン |
| `ui.button.stop` | 停止ボタン |
| `ui.part.new_game_icon` | 新ゲームアイコン |
| `ui.prompt.yes` | プロンプト「はい」 |
| `ui.prompt.no` | プロンプト「いいえ」 |
| `ui.navigation.paw` | ナビゲーション肉球 |
| `ui.draw` | 引き分けインジケータ |

### 5.10 ロールアイコン

| スロット | 説明 |
|---|---|
| `role.organizer` | 主催者ロールアイコン |
| `role.challenger` | 挑戦者ロールアイコン |

---

## 6. 背景

背景設定は manifest の `backgrounds` キーにフィールドゾーンごとに指定する。
背景はスキンパッケージの一部だが、画像アセットスロットとは別に管理される。

### 6.1 対象ゾーン

#### 親ゾーン（常に有効）

| ゾーンキー | 説明 |
|---|---|
| `p1_field` | 上プレイヤーのフィールド領域 |
| `p2_field` | 下プレイヤーのフィールド領域 |
| `battlefield` | バトルフィールド（中央）領域 |
| `scoreboard_main` | スコアボード本体コンテナ |
| `scoreboard_lion` | ライオン配点ストリップ領域 |
| `scoreboard_total` | 合計点表示の塊全体領域 |
| `scoreboard_waiting_background` | スコアボード領域が待機状態の時に表示される背景 |

`scoreboard_waiting_background` はスコアボード正方形領域に他の表示物（スコアボード・ルール選択・ライオン配点入力など）がない待機状態のときのみ表示される条件付き背景である。
他の背景ゾーンと同様に `fit`（`contain` / `cover` など）・`imageOpacity`・`overlayColor` などが利用できる。

#### 追加ゾーン（未設定時は透明）

| ゾーンキー | 説明 |
|---|---|
| `top_controls` | 画面上部のボタン領域 |
| `footer` | 画面下部のフッター領域 |
| `p1_hand` | 上プレイヤー手札表示部分 |
| `p1_icon` | 上プレイヤーアイコン部分 |
| `p1_message` | 上プレイヤーメッセージ表示部分 |
| `p2_hand` | 下プレイヤー手札表示部分 |
| `p2_icon` | 下プレイヤーアイコン部分 |
| `p2_message` | 下プレイヤーメッセージ表示部分 |

追加ゾーン（`top_controls`、`footer`、`p1_hand` 等）は背景のみを描画する。
カードのサイズ・位置・アイコン・メッセージ文字は変更されない。

未設定（エントリなし）の場合は透明として扱われ、親の `p1_field` / `p2_field` 背景がそのまま表示される。
`top_controls` および `footer` は未設定の場合に透明になり、それらの領域に既存の下地色は適用されない。

### 6.2 背景エントリのフィールド

各ゾーンエントリは以下のフィールドをサポートする。すべて省略可能。

| フィールド | 型 | デフォルト | 説明 |
|---|---|---|---|
| `backgroundColor` | string | `"#ffffff"` | 下地色（CSS カラー値） |
| `imageUrl` | string | — | ZIP 内の背景画像ファイルのパス |
| `fit` | string | `"cover"` | 画像のフィットモード（第7章参照） |
| `imageOpacity` | number | `1` | 背景画像の透過率（0.0〜1.0） |
| `overlayColor` | string | — | オーバーレイの色（CSS カラー値） |
| `overlayOpacity` | number | `1` | オーバーレイの透過率（0.0〜1.0） |

### 6.3 背景エントリの例

```json
"backgrounds": {
  "p1_field": {
    "backgroundColor": "#f0f0f0",
    "imageUrl": "backgrounds/p1_field.png",
    "fit": "cover",
    "imageOpacity": 0.9
  },
  "battlefield": {
    "backgroundColor": "#ffffff",
    "overlayColor": "#000000",
    "overlayOpacity": 0.1
  }
}
```

背景設定は必須ではない。エントリがないゾーンはデフォルトの白背景が使用される。

---

## 7. フォント

フォント設定は manifest の `font` キーに指定する。
フォント設定は背景設定とは独立して管理される。

### 7.1 フォントフィールド

| フィールド | 説明 |
|---|---|
| `font.p1_message` | 上プレイヤー（P1）のメッセージ領域の文字色 |
| `font.p2_message` | 下プレイヤー（P2）のメッセージ領域の文字色 |

- 値は CSS カラー文字列（例: `"#000000"`、`"#fff"`、`"rgb(0,0,0)"` など）
- 未設定または不正な色値の場合は既存の文字色をそのまま使用する
- `enabled` フラグはない

### 7.2 フォント設定の形式

現在の標準形式は文字列形式：

```json
"font": {
  "p1_message": "#000000",
  "p2_message": "#ffffff"
}
```

将来拡張として、オブジェクト形式の `color` フィールドも読み取り可能：

```json
"font": {
  "p1_message": { "color": "#000000" },
  "p2_message": { "color": "#ffffff" }
}
```

ただし、UI からの保存は文字列形式で行われる。

### 7.3 フォント設定の適用範囲

- `font.p1_message` は P1 プレイヤーのメッセージ（プロンプト）領域の文字色にのみ適用される
- `font.p2_message` は P2 プレイヤーのメッセージ（プロンプト）領域の文字色にのみ適用される
- カード、アイコン、背景、ボタン画像など他のアセットには影響しない

---

## 8. 画像フィットモード

`fit` フィールドは背景画像をゾーン内にどのように表示するかを制御する。

| 値 | 説明 |
|---|---|
| `cover` | アスペクト比を維持しつつ領域全体を覆うようにスケール。はみ出す場合はクロップされる。 |
| `contain` | アスペクト比を維持しつつ領域内に完全に収まるようにスケール。余白が生じる場合がある。 |
| `tile` | 元のサイズで画像をタイル状に繰り返して領域を埋める。 |
| `stretch` | アスペクト比を無視して領域全体に引き伸ばす。 |

---

## 8. 描画ルール

各ゾーンで以下の順序（下から上）でレイヤーが描画される：

1. `backgroundColor`（下地色）
2. 背景画像（`imageUrl` に `fit` と `imageOpacity` を適用）
3. オーバーレイ（`overlayColor` に `overlayOpacity` を適用）
4. ゲームUI

背景は各ゾーンの最下層に適用される。
背景が設定されていない場合は、デフォルトの白色が使用される（親ゾーン）。

追加ゾーン（`top_controls`、`footer`、`p1_hand`、`p1_icon`、`p1_message`、`p2_hand`、`p2_icon`、`p2_message`）は未設定の場合は透明として扱われる。
子ゾーン（`p1_hand`、`p1_icon`、`p1_message`、`p2_hand`、`p2_icon`、`p2_message`）が未設定の場合は親の `p1_field` / `p2_field` 背景がそのまま見える。

---

## 9. フォールバックの挙動

- `mappings` がない場合は空として扱う。
- スロットキーがない・空文字・`null` の場合、そのスロットは変更されない。
- 参照先ファイルが ZIP 内に存在しない場合、そのスロットは変更されない。
- `backgrounds` がない場合、背景設定は適用されない。
- 親ゾーン（`p1_field`、`p2_field`、`battlefield`、`scoreboard_*`）のエントリがない場合、そのゾーンはデフォルトの白背景が使用される。
- 追加ゾーン（`top_controls`、`footer`、`p1_hand`、`p1_icon`、`p1_message`、`p2_hand`、`p2_icon`、`p2_message`）のエントリがない場合、そのゾーンは透明として扱われる。
- `imageUrl` がない・ファイルが見つからない場合、`backgroundColor` とオーバーレイのみが適用される。
- ZIP の読み込みは追加専用。既存スロットは ZIP のインポートによって削除されない。
- `backgrounds` に未知のゾーンキーがあっても無視される。
- `font` がない場合、フォント設定は変更されない。
- `font.p1_message` / `font.p2_message` が未設定または不正な色値の場合、既存の文字色がそのまま使用される。

---

## 10. 画像ガイドライン

### 対応形式

- PNG
- JPG / JPEG
- SVG（アセットスロット専用。背景への使用は非推奨）
- WebP

### アセット画像

| 項目 | 推奨 |
|---|---|
| ファイルサイズ | 1ファイルあたり 1MB 以内 |
| カラーモード | RGB または RGBA |
| 透明度 | アイコン類は PNG アルファチャンネル推奨 |

### 背景画像

| 項目 | 推奨 |
|---|---|
| ファイルサイズ | 100KB〜200KB |
| 幅 | 256px 前後 |
| 優先事項 | ファイルサイズを最小化すること |

注意：SVG は背景への使用を推奨しない。背景画像は CSS の `background-image` として描画されるが、SVG のレンダリング挙動はブラウザによって異なる。一貫した結果を得るためにラスター形式（PNG・JPG・WebP）を使用すること。

---

## 11. スキンパッケージの作成手順

1. 差し替えたいスロット用の画像ファイルを用意する。
2. `manifest.json` ファイルを作成する（第4章・第13章参照）。
3. 必要に応じて `backgrounds` に背景設定を追加する。
4. すべてのファイルを1つのフォルダに配置する。
5. フォルダの中身を `.zip` ファイルに圧縮する。

### ZIP 内のファイル名ルール

- パスは読み込み時に小文字に正規化される。
- 非 ASCII 文字を含むパスは無視される。
- ASCII 文字のみ使用すること。

### ZIP の作成例（macOS / Linux）

```sh
cd my-skin-folder
zip -r ../my-skin.zip .
```

### ZIP の作成例（Windows）

スキンフォルダの中のファイルをすべて選択し、右クリックして「ZIP ファイルに圧縮」を選択する。

フォルダ自体ではなく、中身を圧縮すること。`manifest.json` が ZIP のルートに配置されるようにする。

---

## 12. スキンのインポート方法

1. ブラウザでゲームを開く。
2. スキンボタンをクリックしてスキンポップアップを開く。
3. 「スキン」タブで「一括」を選択する。
4. 「zipで一括取り込み」をクリックする。
5. `.zip` ファイルを選択する。

読み込み後、スキンが即時反映される。

---

## 13. 例

### 最小の manifest（変更なし）

```json
{}
```

### 手札のみのスキン

```json
{
  "manifestVersion": 1,
  "name": "My Hand Skin",
  "author": "Your Name",
  "mappings": {
    "hand.gu": "gu.png",
    "hand.choki": "choki.png",
    "hand.pa": "pa.png"
  }
}
```

### 背景付きスキン

```json
{
  "manifestVersion": 1,
  "name": "Dark Theme",
  "author": "Your Name",
  "mappings": {
    "hand.gu": "hands/gu.png",
    "hand.choki": "hands/choki.png",
    "hand.pa": "hands/pa.png"
  },
  "backgrounds": {
    "p1_field": {
      "backgroundColor": "#1a1a2e"
    },
    "p2_field": {
      "backgroundColor": "#1a1a2e"
    },
    "battlefield": {
      "backgroundColor": "#16213e",
      "imageUrl": "backgrounds/battlefield.png",
      "fit": "cover",
      "imageOpacity": 0.8
    }
  },
  "font": {
    "p1_message": "#ffffff",
    "p2_message": "#ffffff"
  }
}
```

### フル manifest テンプレート

```json
{
  "manifestVersion": 1,
  "skinId": "your-skin-id",
  "name": "Your Skin Name",
  "author": "Your Name",
  "description": "Optional description",
  "mappings": {
    "phase.exchange_intent": "",
    "phase.exchange_card_select": "",
    "phase.battle": "",
    "hand.gu": "",
    "hand.choki": "",
    "hand.pa": "",

    "card.frame": "",
    "card.back": "",

    "rule.icon.hornet": "",
    "rule.icon.rabbit": "",
    "rule.icon.elephant": "",
    "rule.icon.fox": "",
    "rule.icon.bear": "",
    "rule.icon.turtle": "",
    "rule.icon.crab": "",
    "rule.icon.peacock": "",
    "rule.icon.dolphin": "",
    "rule.icon.lion": "",

    "rule.icon.unknown": "",
    "rule.icon.alien": "",
    "rule.icon.zebra": "",

    "rule.coin.hornet": "",
    "rule.coin.rabbit": "",
    "rule.coin.elephant": "",
    "rule.coin.fox": "",
    "rule.coin.bear": "",
    "rule.coin.turtle": "",
    "rule.coin.crab": "",
    "rule.coin.peacock": "",
    "rule.coin.dolphin": "",

    "point.-1": "",
    "point.0": "",
    "point.1": "",
    "point.2": "",
    "point.lion_increase": "",
    "point.lion_decrease": "",

    "player.p1.human": "",
    "player.p1.cpu": "",
    "player.p1.api": "",
    "player.p1.remote": "",
    "player.p2.human": "",
    "player.p2.cpu": "",
    "player.p2.api": "",
    "player.p2.remote": "",

    "winreason.complete_point_dominance": "",
    "winreason.total_point_lead": "",
    "winreason.by_last_win_fallback": "",
    "winreason.by_rule_matched": "",
    "winreason.draw": "",

    "ui.navigation.paw": ""
  },
  "backgrounds": {
    "p1_field": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p2_field": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "battlefield": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "scoreboard_main": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "scoreboard_lion": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "scoreboard_total": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "top_controls": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "footer": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p1_hand": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p1_icon": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p1_message": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p2_hand": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p2_icon": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    },
    "p2_message": {
      "backgroundColor": "#ffffff",
      "imageUrl": "",
      "fit": "cover",
      "imageOpacity": 1
    }
  },
  "font": {
    "p1_message": "#000000",
    "p2_message": "#000000"
  }
}
```
