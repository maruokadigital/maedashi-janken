# Advice API

Advice API は、前出しじゃんけんに外部AIやプログラムを接続するためのインターフェースです。

ゲームの各フェーズに応じてリクエストが送られ、  
クライアントはそれに対して意思決定（レスポンス）を返します。

---

## 読み方

まずは仕様本体を読んでください。

- 仕様本体  
  → [advice-api-spec.md](advice-api-spec.md)

次に、キーの意味を確認します。

- キー定義（辞書）  
  → [advice-api-key-reference.md](advice-api-key-reference.md)

---

## ドキュメント構成

- [advice-api-spec.md](advice-api-spec.md)  
  API全体の構造・通信仕様・フェーズ別仕様

- [advice-api-key-reference.md](advice-api-key-reference.md)  
  JSONキーの意味・役割・制約の一覧

---

## 想定用途

- AIによる自動プレイ
- CPUロジックの外部実装
- 学習・研究用途
- 教材としての利用

---

## 注意

- このAPIは「内部API」ではなく、外部から利用するためのインターフェースです。
- 実装は言語に依存しません。
- レスポンスは仕様に従う必要があります。

---

## Getting Started

1. [advice-api-spec.md](advice-api-spec.md) を読む  
2. 最小レスポンス（例：1フェーズの決定のみ）を実装する  
3. 1フェーズのみ対応するロジックを作る
