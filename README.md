# 前出しじゃんけん (Maedashi Janken)

手札が見える対戦ゲーム「前出しじゃんけん」の公開リポジトリです。

このリポジトリでは、主に以下を公開しています。

- Advice API（外部AI連携用インターフェース）
- スキン仕様（見た目カスタマイズ用仕様）
- 教材として利用可能なドキュメント
- サンプルデータ・サンプル構成

現時点では、**仕様ドキュメントを中心に先行公開**しています。  
ゲーム本体や教材用コードは、今後段階的に整理・公開していきます。

---

## Documentation

ドキュメントは `docs/` にまとまっています。

- Advice API  
  外部AIと連携するためのインターフェース仕様  
  → `docs/advice-api/`

- Skins  
  UI・カード・アイコンなどの見た目変更仕様  
  → `docs/skins/`

---

## Getting Started

このリポジトリ単体でゲームを起動することは想定していません。  
まずは以下のドキュメントから仕様を確認してください。

- Advice API を使いたい場合  
  → `docs/advice-api/advice-api-spec.md`

- スキンを作成したい場合  
  → `docs/skins/skin-spec.md`

---

## Repository Structure


public-release/
docs/ 仕様ドキュメント
examples/ サンプルデータ・サンプル構成
public/ 画像・スクリーンショット


---

## Roadmap

今後、以下を順次追加予定です。

- Advice API の実装例（複数言語）
- スキンのテンプレート
- 教材用の最小構成コード
- チュートリアル

---

## License

このリポジトリの内容は LICENSE に従います。

※コード・ドキュメント・画像で扱いが異なる場合があります。