# 構成ファイル

Terraformのコードは、`tf`というファイル拡張子を持つプレーンテキストファイルに格納されます。また、`tf.json`というファイル拡張子を持つJSONベースの言語もあります。

- tf
- tf.json (tfの内容と重複不可)

`tf`や`tf.json`の内容を上書きしたい場合に`*_override.tf`と`*_override.tf.json`が用意されています。

- *_override.tf
- *_override.tf.json

Terraformコード内で利用する変数定義を記載する`tfvars`というファイル拡張子も存在します。

- tfvars
