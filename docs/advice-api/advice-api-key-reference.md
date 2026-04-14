# 前出しじゃんけん Advice API キー定義書

## 1. この文書の目的

この文書は、前出しじゃんけん Advice API で使われる各キーの意味を定義するための公開資料である。

本書は主に次を対象とする。

- request / response に含まれる各キーの意味確認
- 型と値域の確認
- 同名キーの役割整理
- API 実装時の読み取り・返却項目の確認

本書は、構造中心の仕様書とは別に、**各キーの意味を辞書的に参照するための文書**として用いる。

---

## 2. トップレベルキー

## 2.1 request

### `version`
- 型: `string`
- 役割: request 全体の公開フォーマットのバージョンを示す。
- 例: `"1.0"`

### `context`
- 型: `object`
- 役割: じゃんけん記号など、対戦全体で共通に参照する文脈情報を持つ。

### `duel`
- 型: `object`
- 役割: 対戦状態本体を表す。勝敗、手札、ラウンド履歴、配点情報などを含む。

### `answer_condition`
- 型: `object`
- 役割: 今回の request が、誰に対して、どの局面で、どの形式の回答を要求しているかを示す。

### `analysis`
- 型: `object`
- 必須性: 任意
- 役割: 対戦状態そのものではない補助情報を持つ。実装によって利用してもよいし、無視してもよい。

---

## 2.2 response

### `answer`
- 型: フェーズ依存
- 役割: Advice API が返す回答本体。
- 補足: 型は `answer_condition.answer_spec.format` により決まる。

### `answer_condition`
- 型: `object`
- 必須性: 任意だが推奨
- 役割: response がどの問い合わせ条件に対応するかを明示する。
- 補足: request から受け取った `answer_condition` をそのまま返す構成を想定する。

### `duel`
- 型: `object`
- 必須性: 任意
- 役割: response 側で対戦状態全体を併記したい場合に使う。
- 補足:
  - フル response では `duel` を含めてよい。
  - request の `duel` をそのまま返してもよい。
  - または、応答時点の補足用スナップショットとして返してもよい。

### `message`
- 型: `string | null`
- 必須性: 任意
- 役割: プレイヤーの発言として扱う表示用メッセージ。

### `comment`
- 型: `string | null`
- 必須性: 任意
- 役割: システムコメント、補足コメント、ログ補助コメントなどに使う。

### `context`
- 型: `object`
- 必須性: 任意
- 役割: response 側で記号対応などを併記したい場合に使う。

---

## 3. `context` のキー定義

### `context.round_index_base`
- 型: `number`
- 役割: ラウンド番号の基準値。
- 例: `0`
- 補足: ラウンド番号が 0 始まりか 1 始まりかを外部に示すための情報。

### `context.janken_mapping`
- 型: `array`
- 役割: じゃんけんの意味名と公開記号の対応表。

各要素は次の構造を持つ。

```json
{
  "meaning": "gu",
  "symbol": "GGG"
}
```

#### `context.janken_mapping[].meaning`
- 型: `string`
- 役割: じゃんけんの意味名。
- 主な値:
  - `gu`
  - `choki`
  - `pa`

#### `context.janken_mapping[].symbol`
- 型: `string`
- 役割: 公開 API 上で実際に使う記号。
- 例:
  - `GGG`
  - `CCC`
  - `PPP`

---

## 4. `duel` のキー定義

## 4.1 対戦全体情報

### `duel.game_selected_rule`
- 型: `string | null`
- 役割: 現在の対戦で採用されているゲームルール名。
- 例: `"lion"`

### `duel.winner`
- 型: `"player1" | "player2" | "draw" | null`
- 役割: 勝者を示す。
- 値の意味:
  - `player1`: player1 が勝者
  - `player2`: player2 が勝者
  - `draw`: 引き分け
  - `null`: 未確定

### `duel.victory_reason`
- 型: `string | null`
- 役割: 勝敗決定理由を示す。
- 許可値:
  - `complete_point_dominance`
  - `total_point_lead`
  - `by_last_win_fallback`
  - `by_rule_matched`
  - `draw`
  - `null`

各値の意味:
- `complete_point_dominance`: 配点基準を問わず優勢が維持され、そのまま勝利したことを表す。
- `total_point_lead`: 総得点差で勝利したことを表す。
- `by_last_win_fallback`: 他の条件で決着しない場合に、最後の勝敗を基準として決着したことを表す。
- `by_rule_matched`: ルール一致により勝利したことを表す。
- `draw`: 引き分け。
- `null`: 未確定。

### `duel.alien_rule_applied`
- 型: `boolean | null`
- 役割: Alien ルールが適用されているかを示す。
- 値の意味:
  - `true`: 適用あり
  - `false`: 適用なし
  - `null`: 不明または未設定

### `duel.player1_rule_selection_status`
### `duel.player2_rule_selection_status`
- 型: `string | null`
- 役割: 各プレイヤーのルール選択権の状態を示す。
- 許可値:
  - `unknown`
  - `has_right`
  - `waived`
  - `no_right`
  - `null`

各値の意味:
- `unknown`: 状態未確定または不明。
- `has_right`: そのプレイヤーに選択権がある。
- `waived`: 選択権を放棄した。
- `no_right`: そのプレイヤーに選択権がない。
- `null`: 情報なし。

---

## 4.2 手札情報

### `duel.player1_initial_hand`
### `duel.player2_initial_hand`
- 型: `string[]`
- 役割: 対戦開始時点の初期手札。

### `duel.player1_last_hand`
### `duel.player2_last_hand`
- 型: `string[]`
- 役割: request 時点でそのプレイヤーが保持している現在手札。
- 補足: キー名に `last` を含むが、実際の意味としては「その時点で残っている手札」である。

---

## 4.3 ライオン関連

### `duel.lion_score_map`
- 型: `object`
- 役割: 各プレイヤーに設定されたライオン配点表。

構造:
```json
{
  "player1": {
    "hornet": 1,
    "rabbit": -1,
    "elephant": 1,
    "fox": 0,
    "bear": 2,
    "turtle": 0,
    "crab": 0,
    "peacock": 0,
    "dolphin": -1
  },
  "player2": {
    "hornet": -1,
    "rabbit": 0,
    "elephant": 1,
    "fox": -1,
    "bear": 2,
    "turtle": 1,
    "crab": -1,
    "peacock": 0,
    "dolphin": 0
  }
}
```

#### `duel.lion_score_map.player1`
#### `duel.lion_score_map.player2`
- 型: `object`
- 役割: 各プレイヤーに対して設定された配点マップ。

以下のキーを持つ。

- `hornet`
- `rabbit`
- `elephant`
- `fox`
- `bear`
- `turtle`
- `crab`
- `peacock`
- `dolphin`

各キーの意味:
- `hornet`: Hornet ルールの配点
- `rabbit`: Rabbit ルールの配点
- `elephant`: Elephant ルールの配点
- `fox`: Fox ルールの配点
- `bear`: Bear ルールの配点
- `turtle`: Turtle ルールの配点
- `crab`: Crab ルールの配点
- `peacock`: Peacock ルールの配点
- `dolphin`: Dolphin ルールの配点

配点制約:
- すべてのキーの最小値は `-1`
- `hornet` と `bear` の最大値は `2`
- それ以外の最大値は `1`

### `duel.lion_total_scores`
- 型: `object | null`
- 役割: プレイヤー視点別の合計得点。

構造:
```json
{
  "player1_view": { "player1": 0, "player2": 4 },
  "player2_view": { "player1": -3, "player2": 2 }
}
```

#### `duel.lion_total_scores.player1_view`
#### `duel.lion_total_scores.player2_view`
- 型: `object`
- 役割: 各視点から見た合計得点。

#### `duel.lion_total_scores.player1_view.player1`
#### `duel.lion_total_scores.player1_view.player2`
#### `duel.lion_total_scores.player2_view.player1`
#### `duel.lion_total_scores.player2_view.player2`
- 型: `number`
- 役割: 各視点における player1 / player2 の合計得点。

---

## 4.4 ラウンド履歴

### `duel.rounds`
- 型: `array`
- 役割: 各ラウンドの詳細履歴を時系列順に保持する。

各要素は次の構造を持つ。

```json
{
  "round": 3,
  "player1_exchange_intent": false,
  "player1_exchange_card": "",
  "player1_battle_card": "",
  "player2_exchange_intent": false,
  "player2_exchange_card": "",
  "player2_battle_card": "",
  "player1_applied_rules": [],
  "player2_applied_rules": [],
  "round_winner": null,
  "lion_scores": {
    "player1_view": { "player1": 0, "player2": 0 },
    "player2_view": { "player1": 0, "player2": 0 }
  }
}
```

### `duel.rounds[].round`
- 型: `number`
- 役割: ラウンド番号。

### `duel.rounds[].player1_exchange_intent`
### `duel.rounds[].player2_exchange_intent`
- 型: `boolean | null`
- 役割: そのラウンドで交換を行う意思。
- 値の意味:
  - `true`: 交換する
  - `false`: 交換しない
  - `null`: 未確定

### `duel.rounds[].player1_exchange_card`
### `duel.rounds[].player2_exchange_card`
- 型: `string`
- 役割: 交換対象として選ばれたカード記号。
- 補足: 未確定または未使用の場合は空文字列 `""` を取る。

### `duel.rounds[].player1_battle_card`
### `duel.rounds[].player2_battle_card`
- 型: `string`
- 役割: そのラウンドで対戦に出したカード記号。
- 補足: 未確定または未使用の場合は空文字列 `""` を取る。

### `duel.rounds[].player1_applied_rules`
### `duel.rounds[].player2_applied_rules`
- 型: `string[]`
- 役割: そのラウンドで適用されたルール名の一覧。

### `duel.rounds[].round_winner`
- 型: `"player1" | "player2" | "draw" | null`
- 役割: そのラウンドの勝者を示す。
- 値の意味:
  - `player1`: player1 がそのラウンドで勝利した。
  - `player2`: player2 がそのラウンドで勝利した。
  - `draw`: そのラウンドは引き分けだった。
  - `null`: 未確定、未実施、または判定前のラウンド。

### `duel.rounds[].lion_scores`
- 型: `object`
- 役割: そのラウンドで発生したライオン得点。

#### `duel.rounds[].lion_scores.player1_view`
#### `duel.rounds[].lion_scores.player2_view`
- 型: `object`
- 役割: 各視点で見たそのラウンドの得点。

#### `duel.rounds[].lion_scores.player1_view.player1`
#### `duel.rounds[].lion_scores.player1_view.player2`
#### `duel.rounds[].lion_scores.player2_view.player1`
#### `duel.rounds[].lion_scores.player2_view.player2`
- 型: `number`
- 役割: そのラウンドの player1 / player2 の得点。

---

## 5. `answer_condition` のキー定義

### `answer_condition.advice_for`
- 型: `"player1" | "player2"`
- 役割: どちらのプレイヤーに対する助言かを示す。

### `answer_condition.advice_at`
- 型: `object`
- 役割: どのラウンドのどのフェーズに対する助言かを示す。

### `answer_condition.advice_at.round`
- 型: `number`
- 役割: 対象ラウンド番号。

### `answer_condition.advice_at.phase`
- 型: `string`
- 役割: 対象フェーズ名。
- 許可値:
  - `battle`
  - `exchange_intent`
  - `exchange_card_select`
  - `lion_score_assign`
  - `rule_selection`
  - `final`

各値の意味:
- `battle`: 対戦カードを選ぶフェーズ。
- `exchange_intent`: 交換するかどうかを決めるフェーズ。
- `exchange_card_select`: 交換に出すカードを選ぶフェーズ。
- `lion_score_assign`: ライオン配点を設定するフェーズ。
- `rule_selection`: ゲームルールを選ぶフェーズ。
- `final`: 試合終了通知フェーズ。

### `answer_condition.answer_spec`
- 型: `object | null`
- 役割: そのフェーズで要求される回答形式を示す。
- 補足: `null` の場合は回答要求なし。

### `answer_condition.answer_spec.format`
- 型: `string`
- 役割: `answer` の期待形式を示す。
- 許可値:
  - `symbol`
  - `boolean_like`
  - `lion_score_map`
  - `rule_name`

各値の意味:
- `symbol`: 文字列記号を返す形式。
- `boolean_like`: `yes` / `no` のようなブール相当文字列を返す形式。
- `lion_score_map`: ルール名をキーとした配点マップを返す形式。
- `rule_name`: ルール名の識別子文字列を返す形式。

### `answer_condition.answer_spec.set`
- 型: `array | null`
- 役割: 回答候補列。
- 補足:
  - `symbol` の場合は候補カード一覧
  - `boolean_like` の場合は `["yes", "no"]`
  - `lion_score_map` の場合は通常 `null`
  - `rule_name` の場合は候補ルール名一覧
- 注意: 数学的集合ではなく、重複を保持する候補列である。

### `answer_condition.answer_spec.template`
- 型: 任意
- 役割: その request に対して最低限返せるテンプレート値。
- 例:
  - `symbol` → `"GGG"`
  - `boolean_like` → `"yes"`
  - `lion_score_map` → 配点オブジェクト
  - `rule_name` → `"lion"`

---

## 6. `analysis` のキー定義

### `analysis.opponent_id`
- 型: `string`
- 役割: 対戦相手の識別名。

### `analysis.strategy`
- 型: `string`
- 役割: 対戦条件や相手に関する補助的な戦略情報。
- 例: `"clever"`

### `analysis.strategy_apply_rate`
- 型: `number`
- 必須性: 任意
- 範囲: `0.0` ～ `1.0`
- 役割: 本戦略を適用する確率を示す。
- 未指定時: `1.0` として扱う。

---

## 7. `answer` の意味

`response.answer` の意味は `answer_condition.advice_at.phase` と `answer_condition.answer_spec.format` に依存する。

| phase | format | `answer` の意味 | 型 | 例 |
|---|---|---|---|---|
| `rule_selection` | `rule_name` | 選択ルール名 | `string` | `"lion"` |
| `lion_score_assign` | `lion_score_map` | ライオン配点表 | `object` | `{ "hornet": 0, ... }` |
| `exchange_intent` | `boolean_like` | 交換するかどうか | `string` | `"yes"` |
| `exchange_card_select` | `symbol` | 交換に出すカード | `string` | `"CCC"` |
| `battle` | `symbol` | 出すカード | `string` | `"GGG"` |
| `final` | `null` | 通常は未使用 | 任意 | `null` |

---

## 8. `message` と `comment` の意味

### `response.message`
- 役割: プレイヤーが発言したように表示するためのメッセージ。
- 用途例:
  - UI 上のひとこと表示
  - 対戦中の雰囲気付け
  - API らしさの演出

### `response.comment`
- 役割: システムコメントまたは補足コメント。
- 用途例:
  - 記録補助
  - ログ補足
  - 説明用コメント

---

## 9. 最小実装時に最低限理解すべきキー

Advice API を最小実装する場合、最低限重要なのは次のキーである。

### request 側
- `context`
- `duel`
- `answer_condition`

### response 側
- `answer`

---

## 10. 最小レスポンス例

```json
{
  "answer": "GGG"
}
```
