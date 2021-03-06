# Terraform の紹介

## Terraformとは

`Terraform`は、[HashiCorp](https://www.hashicorp.com/)社のInfrastructure as Codeツールです。インフラの構築、変更、管理を安全、かつ、反復可能な方法で行なうためのツールです。オペレーターやインフラチームは、Terraformを使って、`HashiCorp Configuration Language (HCL)`と呼ばれる設定言語で環境を管理し、人間が読めるように自動化されたデプロイメントを行なうことができます。

## Infrastructure as Codeとは

`Infrastructure as Code (IaC)`とは、ユーザーインターフェースでリソースを手動設定するのではなく、ファイルでインフラストラクチャを管理するプロセスのことです。ここで言うリソースとは、仮想マシン、セキュリティグループ、ネットワークインターフェースなどの特定の環境におけるインフラの一部を指します。

Terraformでは、オペレーターが`HCL`を利用して、ほぼすべてのプロバイダー(AWS、GCP、GitHub、Docker等)の必要なリソース定義を含むファイルを作成し、適宜、そのリソースの作成を自動化できます。

## Terraformを利用するメリット・デメリット

### メリット

- Git管理でき、コードレビューが可能になる
- 一度インフラ構成をコード化してしまえば、別の環境や別プロジェクトで再利用が可能になる
- Terraformの静的チェックが入るので、人的ミスが防げる

### デメリット

- `AWS CloudFormation`に比べると新機能の反映が遅い
- 手動でインフラ構成を変更するとTerraformに差分が発生してしまう
