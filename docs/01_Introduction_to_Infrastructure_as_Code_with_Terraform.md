# Terraform の紹介

## Terraform とは

`Terraform` は、[HashiCorp](https://www.hashicorp.com/) 社の Infrastructure as Code ツールです。インフラの構築、変更、管理を安全、かつ、反復可能な方法で行う為のツールです。オペレーターやインフラチームは、`Terraform` を使って、`HashiCorp Configuration Language (HCL)` と呼ばれる設定言語で環境を管理し、人間が読めるように自動化されたデプロイメントを行うことが出来ます。

## Infrastructure as Code とは

`Infrastructure as Code (IaC)` とは、ユーザーインターフェースでリソースを手動設定するのではなく、ファイルでインフラストラクチャを管理するプロセスのことです。ここで言うリソースとは、仮想マシン、セキュリティグループ、ネットワークインターフェース等の特定の環境におけるインフラの一部を指します。

`Terraform` では、オペレーターが `HCL` を利用して、ほぼ全てのプロバイダー(AWS、GCP、GitHub、Docker等)の必要なリソース定義を含むファイルを作成し、適宜、そのリソースの作成を自動化することが出来ます。

## Terraform を利用するメリット・デメリット

### メリット

- Git 管理でき、コードレビューが可能になる
- 一度インフラ構成をコード化してしまえば、別の環境や別プロジェクトで再利用が可能になる
- Terraform の静的チェックが入るので、人為的ミスが防げる

### デメリット

- `v1` に到達していないので、バージョンアップで破壊的な変更が入るリスクが有る
- `AWS CloudFormation` に比べると新機能の反映が遅い
- 手動でインフラ構成を変更すると `Terraform` に差分が発生してしまう

## Terraform を構成するファイル

`Terraform` のコードは、`tf` というファイル拡張子を持つプレーンテキストファイルに格納されます。また、`tf.json` というファイル拡張子を持つJSONベースの言語もあります。

- tf
- tf.json (tfの内容と重複不可)

`tf` や `tf.json` の内容を上書きしたい場合に `*_override.tf` と `*_override.tf.json` が用意されています。

- *_override.tf
- *_override.tf.json

`Terraform` コード内で利用する変数定義を記載する `tfvars` というファイル拡張子も存在します。

- tfvars
