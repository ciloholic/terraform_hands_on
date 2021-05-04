# 事前準備

## Terraform用のIAMを用意する

`AdministratorAccess`権限が付与されたIAMを用意してください。今回はハンズオンのため、`AdministratorAccess`権限を付与していますが、基本的に必要最低限の権限を付与するのが推奨されます。

ユーザーの「認証情報」タブからアクセスキーを発行してください。その際に「アクセスキー」と「シークレットキー」が表示されるのでメモしておいてください。

## 環境変数を用意する

`src/terraform.tfvars.sample`をコピーし、`src/terraform.tfvars`を作成します。下記のように環境変数を設定します。

```
# aws config
aws_access_key = "アクセスキーを記入してください"
aws_secret_key = "シークレットキーを記入してください"

# service config
service_name = "hands-on"
env          = "dev"
```

## 実行コマンドの説明

`src`配下にディレクトリを移動すると、下記のようなTerraformのコマンドを実行できます。他のコマンドは`terraform -h`で確認ができます。

- terraform init
    - 作業ディレクトリを準備する
- terraform plan
    - 実行計画を表示する
- terraform apply
    - インフラの作成・更新する
- terraform destroy
    - インフラを破棄する
- terraform validate
    - 正常な設定か確認する
- terraform fmt -recursive
    - フォーマットを整形する

上記の実行コマンドのショートカットを`Makefile`で作成しています。本ハンズオンでは下記の実行コマンドで説明していきます。`make`コマンドで実行する場合は、`src`ディレクトリに移動する必要はありません。

```
$ make init
$ make plan
$ make apply
$ make destroy
$ make val
$ make fmt
```
