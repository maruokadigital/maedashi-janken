# 前出しじゃんけん Advice API 仕様書（公開版）

## 1. 概要

本仕様書は、前出しじゃんけんにおいて利用される Advice API の公開仕様を定義する。

Advice API は、ゲーム本体が送信する対戦状態（request）に対し、外部の API 実装が応答（response）を返すことで、プレイヤーの行動を決定するためのインターフェースである。

この文書では、特に request 側の公開 JSON 構造を中心に定義する。

---

## 1.1 共通仕様：文字列の大文字小文字の扱い

本システムが外部から受け付ける JSON では、キー名および識別用途の文字列値（実質キー）について、大文字小文字を区別しない。

### 対象

以下のような、内部処理で識別・分岐に使用される文字列値を対象とする。

- `analysis.strategy`
- `answer_spec.format`
- `answer_condition.advice_for`
- `answer_condition.advice_at.phase`
- ルール名（rule）
- その他、列挙値・識別子として扱われる文字列

### 挙動

これらの値は、次のように扱われる。

- `"clever"` / `"Clever"` / `"CLEVER"` は同一
- `"predictable"` / `"Predictable"` / `"PREDICTABLE"` は同一
- `"lion"` / `"Lion"` / `"LION"` は同一
- `"battle"` / `"Battle"` / `"BATTLE"` は同一

実装は受信時に適切に正規化して解釈するものとする。

### 注意

- 本仕様はキー名にも適用される（例：`analysis` / `Analysis` など）
- 自由記述のテキスト（例：メッセージ本文など）は対象外である

---

## 2. 通信仕様

### 2.1 メソッド

Advice API は HTTP POST を使用する。

### 2.2 データ形式

- request: JSON
- response: JSON

### 2.3 URL

URL は実装者が自由に定義する。

例:

- `/advice`
- `/advice-cors`
- `/api/advice`

#### 実装例（本体サーバ）

- `POST /api/advice`
- `POST /api/advice-cors`

---

## 3. request の基本構造

request は次のトップレベル構造を持つ。

```json
{
  "version": "1.0",
  "game_instance_id": "5481c6a7-e1d0-4eab-a1dc-4dd82f82e0bd",
  "game_started_at": 1776126498090,
  "game_started_at_iso": "2026-04-22T14:36:10.728+09:00",
  "context": {},
  "duel": {},
  "answer_condition": {},
  "analysis": {}
}
```

### トップレベルキー

- `version`
- `game_instance_id`
- `game_started_at`
- `game_started_at_iso`
- `context`
- `duel`
- `answer_condition`
- `analysis`

---

## 4. response の基本構造

response は少なくとも `answer` を返す。

最小構成では `answer` のみでもよい。  
必要に応じて `message`、`comment`、`answer_condition`、`context`、`duel` を追加してよい。

### 最小例

```json
{
  "answer": "G"
}
```

### 教材用例

```json
{
  "answer": "G",
  "message": "Hello, World!"
}
```

### 推奨例

```json
{
  "answer": "G",
  "answer_condition": {
    "advice_for": "player2",
    "advice_at": {
      "round": 0,
      "phase": "battle"
    },
    "answer_spec": {
      "format": "symbol",
      "set": ["G", "C", "P"],
      "template": "G"
    }
  },
  "message": "battle を選びました"
}
```

### フル例

```json
{
  "answer": "G",
  "answer_condition": {},
  "context": {},
  "duel": {},
  "message": "battle を選びました",
  "comment": "debug info"
}
```

---

## 5. 実際の request 例

以下は、実際の公開 request 構造に沿った例である。

```json
{
  "version": "1.0",
  "game_instance_id": "5481c6a7-e1d0-4eab-a1dc-4dd82f82e0bd",
  "game_started_at": 1776126498090,
  "game_started_at_iso": "2026-04-22T14:36:10.728+09:00",
  "context": {
    "round_index_base": 0,
    "janken_mapping": [
      {
        "meaning": "gu",
        "symbol": "G"
      },
      {
        "meaning": "choki",
        "symbol": "C"
      },
      {
        "meaning": "pa",
        "symbol": "P"
      }
    ]
  },
  "duel": {
    "player1_initial_hand": ["P", "P", "P", "C", "C", "G"],
    "player2_initial_hand": ["C", "C", "G", "G", "G", "G"],
    "player1_last_hand": ["P", "P", "P", "C", "C", "G"],
    "player2_last_hand": ["C", "C", "G", "G", "G", "G"],
    "rounds": [
      {
        "round": 0,
        "player1_exchange_intent": true,
        "player1_exchange_card": "",
        "player1_battle_card": "",
        "player2_exchange_intent": false,
        "player2_exchange_card": "",
        "player2_battle_card": "",
        "player1_applied_rules": [],
        "player2_applied_rules": [],
        "round_winner": null,
        "lion_scores": {
          "player1_view": {
            "player1": 0,
            "player2": 0
          },
          "player2_view": {
            "player1": 0,
            "player2": 0
          }
        }
      }
    ],
    "game_selected_rule": "lion",
    "winner": null,
    "victory_reason": null,
    "alien_rule_applied": true,
    "player1_rule_selection_status": "no_right",
    "player2_rule_selection_status": "no_right",
    "lion_score_map": {
      "player1": {
        "hornet": 1,
        "rabbit": 1,
        "elephant": 0,
        "fox": 1,
        "bear": -1,
        "turtle": -1,
        "crab": 1,
        "peacock": 1,
        "dolphin": -1
      },
      "player2": {
        "hornet": -1,
        "rabbit": 1,
        "elephant": 1,
        "fox": -1,
        "bear": 1,
        "turtle": -1,
        "crab": 0,
        "peacock": -1,
        "dolphin": -1
      }
    },
    "lion_total_scores": {
      "player1_view": {
        "player1": 0,
        "player2": 0
      },
      "player2_view": {
        "player1": 0,
        "player2": 0
      }
    }
  },
  "answer_condition": {
    "answer_spec": {
      "format": "symbol",
      "set": ["C", "C", "G", "G", "G", "G"],
      "template": "G"
    },
    "advice_for": "player2",
    "advice_at": {
      "round": 0,
      "phase": "exchange_card_select"
    }
  },
  "analysis": {
    "strategy_apply_rate": 0.5,
    "strategy": "clever"
  }
}
```

---

## 6. context

### `context.round_index_base`

- 型: `number`
- 意味: ラウンド番号の基準値
- 例: `0`

### `context.janken_mapping`

- 型: `array`
- 意味: じゃんけんの意味名と公開記号の対応表

各要素は次の構造を持つ。

```json
{
  "meaning": "gu",
  "symbol": "G"
}
```

---

## 7. answer_condition

### `answer_condition.advice_for`

- `"player1"` | `"player2"`

### `answer_condition.advice_at.phase`

許可値:

- `battle`
- `exchange_intent`
- `exchange_card_select`
- `lion_score_assign`
- `rule_selection`
- `final`

### `answer_condition.advice_at.round`

- 型: `number`
- 意味: 問い合わせ対象ラウンド番号

---

## 8. answer_spec

### `answer_spec.format`

許可値:

- `symbol`
- `boolean_like`
- `lion_score_map`
- `rule_name`

### フェーズ対応表

| phase | format | answer型 | 例 |
|------|--------|---------|----|
| rule_selection | rule_name | string | `"lion"` |
| lion_score_assign | lion_score_map | object | `{...}` |
| exchange_intent | boolean_like | string | `"yes"` |
| exchange_card_select | symbol | string | `"G"` |
| battle | symbol | string | `"G"` |
| final | null | なし | - |

### `answer_spec.set`

- 型: フェーズ依存
- 意味: その問い合わせで回答として許可される候補の集合

例:

- `symbol` のとき: `["G", "C", "P"]`
- `boolean_like` のとき: `["yes", "no"]`
- `rule_name` のとき: `["hornet", "rabbit", ... , "zebra"]`

### `answer_spec.template`

- 型: フェーズ依存
- 意味: 実装者向けのサンプル値
- 補足: 回答のひな形であり、そのまま返してよい

---

## 9. analysis

### `analysis.strategy`

- 型: `string`
- 意味: 使用する戦略名
- 例: `"clever"`
- 補足: 大文字小文字を区別しない

### `analysis.strategy_apply_rate`

- 型: `number`
- 範囲: `0.0 ～ 1.0`
- 意味: 本戦略を適用する確率
- 補足: 未指定時の扱いは実装依存とする

### `analysis.opponent_id`

- 型: `string`
- 必須性: 任意
- 意味: 外部実装側で相手識別に使うための補助情報

---

## 10. duel.victory_reason

許可値:

- `complete_point_dominance`
- `total_point_lead`
- `by_last_win_fallback`
- `by_rule_matched`
- `draw`

---

## 11. duel.rounds[].round_winner

各ラウンドの勝者を示す。

許可値:

- `player1`: player1 がそのラウンドで勝ちとなった
- `player2`: player2 がそのラウンドで勝ちとなった
- `draw`: そのラウンドは引き分け
- `null`: 未確定、未実施、または判定前

---

## 12. rule_selection_status

許可値:

- `unknown`
- `has_right`
- `waived`
- `no_right`
- `null`

---

## 13. ライオン配点制約

| ルール | 最小 | 最大 |
|------|------|------|
| hornet | -1 | 2 |
| bear | -1 | 2 |
| その他 | -1 | 1 |

---

## 14. 対戦状態判定

### 対戦中

`answer_condition.answer_spec != null`

### 試合終了

`answer_condition.answer_spec == null`

---

## 15. 最小レスポンス例

最小限の実装では、1つのフェーズに対して単純な意思決定を返すだけでも動作する。

以下は、勝負フェーズ（battle）の最小レスポンス例である。

```json
{
  "answer": "G"
}
```
