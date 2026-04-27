# Documentation

このディレクトリには、前出しじゃんけんの公開仕様ドキュメントが含まれています。

---

## 構成

### 全体概要

- 概要  
  → [overview.md](overview.md)

### Advice API

外部AIやプログラムからゲームに参加するためのAPI仕様です。

- 入口  
  → [advice-api/README.md](advice-api/README.md)

- 仕様本体  
  → [advice-api/advice-api-spec.md](advice-api/advice-api-spec.md)

- キー定義（辞書）  
  → [advice-api/advice-api-key-reference.md](advice-api/advice-api-key-reference.md)

### スキンパッケージ

画像アセットや背景をまとめたスキン ZIP の仕様です。

- ガイド本体  
  → [skin-package-guide.md](skin-package-guide.md)

### パターンJSON

前出しじゃんけんのパターンJSON（手札構成・確率・ナッシュ均衡）の仕様です。

- ガイド本体  
  → [pattern-json-guide.md](pattern-json-guide.md)

---

## 読み方

目的別に、以下の順で読むことを推奨します。

### まず全体像を知りたい場合

1. [overview.md](overview.md)
2. 必要に応じて [advice-api/README.md](advice-api/README.md) または [skin-package-guide.md](skin-package-guide.md)

### Advice API を使う場合

1. [advice-api/advice-api-spec.md](advice-api/advice-api-spec.md)
2. [advice-api/advice-api-key-reference.md](advice-api/advice-api-key-reference.md)

### スキンを作る場合

1. [skin-package-guide.md](skin-package-guide.md)

### パターンJSONを使う場合

1. [pattern-json-guide.md](pattern-json-guide.md)

---

## 注意

このディレクトリの内容は、第三者向けに整理された公開仕様です。  
内部実装や開発用資料は含まれていません。
