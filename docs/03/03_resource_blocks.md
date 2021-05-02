# リソースブロック

リソースは、`Terraform` 言語の中で最も重要な要素です。各リソースブロックには、仮想ネットワーク、コンピュートインスタンス、DNSレコードなどの上位コンポーネントなど、1つまたは複数のインフラストラクチャオブジェクトが記述されます。

## リソースタイプ

各リソースは、1つのリソースタイプに関連付けられており、リソースが管理するインフラストラクチャオブジェクトの種類や、リソースがサポートする引数やその他の属性を決定します。

### プロバイダ

```
provider "aws" {
  access_key = "XXXXXXXXXXXX"
  secret_key = "YYYYYYYYYYYY"
  region     = "ap-northeast-1"
}
```

各リソースタイプは、リソースタイプのコレクションを提供する `Terraform` のプラグインであるプロバイダによって実装されます。プロバイダは通常、単一のクラウドまたはオンプレミスのインフラストラクチャプラットフォームを管理する為のリソースを提供します。

リソースを管理する為には、`Terraform` モジュールが必要とするプロバイダを指定する必要があります。また、ほとんどのプロバイダはリモートAPIにアクセスする為に何らかの設定が必要であり、ルートモジュールでその設定を行う必要があります。

### リソース引数

```
resource "aws_instance" "example" {
  ami           = "abc123"
  instance_type = "t3.micro"
}
```

リソースブロックのボディ内のほとんどの引数は、選択されたリソースタイプに固有のものです。リソースタイプのドキュメントには、どのような引数が利用できるか、またその値がどのようにフォーマットされるかが記載されています。

リソース引数の値には、式やその他の `Terraform` 言語の動的機能を利用することができます。

### リソースタイプのドキュメント

`Terraform` プロバイダには、リソースタイプとその引数を説明する独自のドキュメントがあります。

公開されているほとんどのプロバイダは、`Terraform Registry` で配布されており、そのドキュメントも提供されています。

## メタ引数

`Terraform` 言語は、いくつかのメタ引数を定義しており、リソースの動作を変更する為に任意のリソースタイプで使用することが出来ます。

- depends_on
    - リソースの依存関係を指定します
- count
    - 数に応じて複数リソースを作成します
- for_each
    - `map` や文字列の `set` に応じて複数リソースを作成します
- provider
    - デフォルト以外のプロバイダを選択する為に使用します
- lifecycle
    - ライフサイクルのカスタマイズを行います
- provisioner and connection
    - リソースの作成後に追加のアクションを行うためのものです

### depends_on

`Terraform` が自動的に推論出来ないリソースやモジュールの依存関係を扱うには、`depends_on` メタ引数を使用します。

依存関係を明示的に指定する必要があるのは、リソースやモジュールが他のリソースの動作に依存しているが、引数でそのリソースのデータにアクセスしていない場合のみです。

```
# ロール
resource "aws_iam_role" "example" {
  name               = "example"
  assume_role_policy = "..."
}

# ロールポリシー
resource "aws_iam_role_policy" "example" {
  name = "example"
  # この表現は、ロールを参照している為、
  # Terraform は、ロールを初めに作成する必要が有ることを自動的に推測します
  role = aws_iam_role.example.name
}

# インスタンスプロファイル
resource "aws_iam_instance_profile" "example" {
  role = aws_iam_role.example.name
}

# EC2インスタンス
resource "aws_instance" "example" {
  ami           = "ami-abc123"
  instance_type = "t3.micro"

  # Terraform は、インスタンスプロファイルをEC2インスタンスより前に作成する必要が有ることを自動的に推論します
  iam_instance_profile = aws_iam_instance_profile.example

  depends_on = [aws_iam_role_policy.example]
}
```

### count

`count` は `Terraform` 言語で定義されたメタ引数です。モジュールや全てのリソースタイプで使用することが出来ます。

`count` メタ引数には、整数を指定することでリソースまたはモジュールのインスタンスをその数分だけ作成します。

```
resource "aws_instance" "example" {
  # 4台分のEC2インスタンスを作成する
  count = 4

  ami           = "ami-abc123"
  instance_type = "t3.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
```

### for_each

`for_each` は、`Terraform` 言語で定義されたメタ引数です。モジュールや全てのリソースタイプで使用することが出来ます。

`for_each` メタ引数は、`map` または文字列の `set` を受け取り、その `map` または `set` 内の各アイテムのインスタンスを作成します。

```
# map
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}
```

```
# 文字列の set
resource "aws_iam_user" "example" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
```

### provider

モジュールブロックでは、オプションの `providers` メタ引数で、どのプロバイダ設定を適用するかを指定出来ます。

```
# デフォルト設定
provider "aws" {
  region = "ap-northeast-1"
}

# 「virginia」というエイリアスで別リージョンが定義されます
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# provider メタ引数は、デフォルト設定ではなく、
# エイリアスが virginia である aws プロバイダ設定を選択します
resource "aws_instance" "example" {
  ami           = "ami-abc123"
  instance_type = "t3.micro"
  providers     = aws.virginia
}
```

### lifecycle

`lifecycle` は、リソースブロック内に存在するネストされたブロックです。ライフサイクルブロックとその内容はメタ引数であり、タイプを問わず全てのリソースブロックで利用出来ます。

```
resource "*" "example" {
  # ...

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [
        name,
        tags
    ]
  }
}
```

- create_before_destroy
    - デフォルトでは、更新出来ないリソース引数を変更しなければならない場合、`Terraform` が代わりに既存オブジェクトを破壊してから、新規オブジェクトを作成します
- prevent_destroy
    - `true` に設定すると `Terraform` はリソースに関連付けられたインフラストラクチャオブジェクトを破壊が出来ません
- ignore_changes
    - 関連するリモートオブジェクトの更新を計画する際、`Terraform` が無視すべきリソース属性を指定します

## プロビジョナー

プロビジョナーは、サーバやその他のインフラストラクチャオブジェクトのサービスを準備する為、ローカルマシンまたはリモートマシン上で特定のアクションをモデル化する為に使用出来ます。

本ハンズオンでは使用しない為、詳細な説明は省きます。

- file
    - `Terraform` を実行しているマシンから、新しく作成されたリソースにファイルやディレクトリをコピーする為に使用します
- local-exec
    - リソースが作成された後、`Terraform` を実行するマシン上で実行ファイルを起動します
- remote-exec
    - リモートリソースが作成された後、そのリソース上で実行ファイルを起動します
