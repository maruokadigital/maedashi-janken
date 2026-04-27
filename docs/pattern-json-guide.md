# パターンJSON ガイド

このドキュメントは、前出しじゃんけんのパターンJSONの仕様を説明します。

---

## 正本について

パターンJSONの正本は以下に置かれています。

```
- 2枚版
 [public/topologies/2-hands-topologies.json](public/topologies/2-hands-topologies.json)
- 6枚版
 [public/topologies/6-hands-topologies.json](public/topologies/6-hands-topologies.json)
```


## ファイルの用途

### 6枚版（6-hands-topologies.json）

- 初期配布フェーズで使用します。
- 各プレイヤーが6枚の手札を持つ状態のパターンを定義します。
- 確率加重ランダム配布や均等配布に使用します。

### 2枚版（2-hands-topologies.json）

- 第5ラウンド（最終ラウンド）で使用します。
- 各プレイヤーが2枚の手札を持つ状態のパターンを定義します。
- 交換フェーズ・勝負フェーズのナッシュ均衡分析に使用します。

---

## フィールド仕様

### トップレベル

| フィールド | 型 | 説明 |
|---|---|---|
| `probability_denominator` | number | 確率の分母。全パターンの `probability_numerator` の合計と等しくなります。 |
| `patterns` | array | パターンエントリの配列。 |

---

### patterns[i].hands

```json
"hands": [[a0, a1, a2], [b0, b1, b2]]
```

- `hands[0]` = プレイヤー1（P1）の手札構成
- `hands[1]` = プレイヤー2（P2）の手札構成

各配列の要素は抽象カード種の枚数です。

| インデックス | 意味 |
|---|---|
| index 0 | 抽象カード種 0 の枚数 |
| index 1 | 抽象カード種 1 の枚数 |
| index 2 | 抽象カード種 2 の枚数 |

抽象カード種は実際のカード種（Gu/Pa/Choki）と1対1に対応しますが、
パターン照合時にシフト（循環変換）によって対応付けられます。

---

### patterns[i].probability_numerator

- 型: number
- 意味: このパターンが自然に発生する相対確率の分子。
- `probability_denominator` で割った値が実際の確率になります。

---

### patterns[i].nash_outcome（2枚版のみ）

```json
"nash_outcome": {
  "no_exchange": "win_fixed" | "draw_fixed" | "mixed",
  "with_exchange": "win_fixed" | "draw_fixed" | "mixed"
}
```

- `no_exchange`: 交換なしの場合のナッシュ均衡結果
- `with_exchange`: 交換ありの場合のナッシュ均衡結果

#### 値の意味

| 値 | 意味 |
|---|---|
| `win_fixed` | 合理的均衡でどちらかの勝ちが確定する。勝者方向はJSONに記載しない。 |
| `draw_fixed` | 合理的均衡で引き分けが確定する。 |
| `mixed` | ナッシュ均衡に従う混合戦略になる。純粋均衡は存在しない。 |

---

### patterns[i].exchange_effect（2枚版のみ）

```json
"exchange_effect": "none" | "change"
```

| 値 | 意味 |
|---|---|
| `none` | 合理的には交換を要求しない。相手が交換を要求した場合でも、盤面同値クラスが変わらないカードを渡す。 |
| `change` | 合理的には不利側が交換を要求し、強制交換によって盤面同値クラスが変化する。 |

---

## 照合仕様（PatternMatcher）

パターンJSONの照合では、以下の変換を使用します。

### shift（カード種循環）

- 抽象カード種 j を実カード種 (j + shift) % 3 として解釈します。
- shift を 0, 1, 2 で試行し、いずれかで一致するものを探します。
- 照合後、JSONの推奨抽象カード j を実カードに戻す場合は (j + shift) % 3 を使います。

### flip（プレイヤー反転）

- flip=false: hands[0] = 実P1, hands[1] = 実P2
- flip=true: hands[0] = 実P2, hands[1] = 実P1
- flip=true の場合、有利側・不利側・選択側も必ず補正します。

---

## 注意事項

- PatternMatcher 側では循環変換を `shift`、プレイヤー反転を `flip` と呼びます。
