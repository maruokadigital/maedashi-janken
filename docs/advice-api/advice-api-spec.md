# 前出しじゃんけん Advice API 仕様書（公開版）

## 1. 概要
本仕様書は、前出しじゃんけんにおいて利用される Advice API の公開仕様を定義する。

Advice API は、ゲーム本体が送信する対戦状態（request）に対し、API 実装が応答（response）を返すことで、プレイヤーの行動を決定する。

---

## 1.1 共通仕様：文字列の大文字小文字の扱い

本システムが外部から受け付ける JSON では、キー名および識別用途の文字列値（実質キー）について、大文字小文字を区別しない。

### 対象

以下のような、内部処理で識別・分岐に使用される文字列値を対象とする。

- `analysis.strategy`
- `answer_spec.format`
- `phase`
- ルール名（rule）
- その他、列挙値・識別子として扱われる文字列

### 挙動

これらの値は、次のように扱われる。

- `"clever"` / `"Clever"` / `"CLEVER"` は同一
- `"predictable"` / `"Predictable"` / `"PREDICTABLE"` は同一

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

response は最小限の `answer` のみでもよいが、実装や教材用途に応じて `message`、`answer_condition`、`context`、`duel`、`comment` を追加してよい。

- 最小:
  - `answer`
- 教材用:
  - `answer`
  - `message`
- 推奨:
  - `answer`
  - `answer_condition`
  - `context`
  - `message`
- フル:
  - `answer`
  - `answer_condition`
  - `duel`
  - `context`
  - `message`
  - `comment`
最小例:

```json
{
  "answer": "GGG"
}
```
教材用例:
```json
{
  "answer": "GGG",
  "message": "Hello,World!"
}
```
推奨例:
```json
{
  "answer": "GGG",
  "answer_condition": {},
  "context": {},
  "message": "Hello,World!"
}
```
フル例:
```json
{
  "answer": "GGG",
  "answer_condition": {},
  "duel": {},
  "context": {},
  "message": "Hello,World!",
  "comment": "debug info"
}
```

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
- rule_name

### フェーズ対応表

| phase | format | answer型 | 例 |
|------|--------|---------|----|
| rule_selection | rule_name | string | "lion" |
| lion_score_assign | lion_score_map | object | {...} |
| exchange_intent | boolean_like | string | "yes" |
| exchange_card_select | symbol | string | "CCC" |
| battle | symbol | string | "GGG" |
| final | null | なし | - |

---

## 5.1 analysis

### strategy
- 型: string
- 意味: 使用する戦略の名前。
- 例: `"clever"`
- 補足: 大文字小文字を区別しない。`"clever"`、`"Clever"`、`"CLEVER"` はすべて同一として扱われる。

### strategy_apply_rate
- 型: number
- 範囲: 0.0 ～ 1.0
- 意味: 本戦略を適用する確率。未指定時は 1.0 として扱う。

---

## 6. duel.victory_reason

許可値:
- complete_point_dominance
- total_point_lead
- by_last_win_fallback
- by_rule_matched
- draw

---

## 6.1 duel.rounds[].round_winner

各ラウンドの勝者を示す。

許可値:
- `player1`: player1 がそのラウンドで勝利した。
- `player2`: player2 がそのラウンドで勝利した。
- `draw`: そのラウンドは引き分けだった。
- `null`: 未確定、未実施、または判定前。

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

以下は、battle フェーズの最小レスポンス例です。

```json
{
  "answer": "GGG"
}
