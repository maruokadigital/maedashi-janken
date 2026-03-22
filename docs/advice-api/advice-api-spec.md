# 前出しじゃんけん Advice API 仕様書（公開版）

## 1. 概要
本仕様書は、前出しじゃんけんにおいて利用される Advice API の公開仕様を定義する。

Advice API は、ゲーム本体が送信する対戦状態（request）に対し、API 実装が応答（response）を返すことで、プレイヤーの行動を決定する。

---

## 2. 通信仕様

### 2.1 メソッド
Advice API は HTTP POST を使用する。

### 2.2 データ形式
- request: JSON
- response: JSON

### 2.3 URL
URLは実装者が自由に定義する。

例:
- /advice
- /advice-cors
- /api/advice

#### 実装例（本体サーバ）
- POST /api/advice
- POST /api/advice-cors

---

## 3. 基本構造

### request
{
  "version": "1.0",
  "context": {},
  "duel": {},
  "answer_condition": {},
  "analysis": {}
}

### response
{
  "answer": "GGG",
  "message": "string"
}

---

## 4. answer_condition

### advice_for
- "player1" | "player2"

### phase
- battle
- exchange_intent
- exchange_card_select
- lion_score_assign
- rule_selection
- final

---

## 5. answer_spec

### format
- symbol
- boolean_like
- lion_score_map

### フェーズ対応表

| phase | format | answer型 | 例 |
|------|--------|---------|----|
| battle | symbol | string | "GGG" |
| exchange_intent | boolean_like | string | "yes" |
| exchange_card_select | symbol | string | "CCC" |
| lion_score_assign | lion_score_map | object | {...} |
| rule_selection | string | string | "lion" |
| final | null | なし | - |

---

## 6. duel.victory_reason

許可値:
- complete_point_dominance
- total_point_lead
- by_last_win_fallback
- by_rule_matched
- draw

---

## 7. rule_selection_status

許可値:
  - unknown
  - has_right
  - waived
  - no_right
  - null

---

## 8. ライオン配点制約

| ルール | 最小 | 最大 |
|------|------|------|
| hornet | -1 | 2 |
| bear | -1 | 2 |
| その他 | -1 | 1 |

---

## 9. 対戦状態判定

### 対戦中
answer_spec != null

### 試合終了
answer_spec == null

---

## 10. 最小レスポンス例

最小限の実装では、1つのフェーズに対して単純な意思決定を返すだけでも動作します。

以下は、ルール選択フェーズにおける最小レスポンス例です。

```json
{
  "answer": "GGG",
}
