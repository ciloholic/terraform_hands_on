# リソースブロック

リソースは、Terraform言語の中でもっとも重要な要素です。各リソースブロックには、仮想ネットワーク、コンピュートインスタンス、DNSレコードなどの上位コンポーネントなど、1つまたは複数のインフラストラクチャオブジェクトが記述されます。

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

各リソースタイプは、リソースタイプのコレクションを提供するTerraformのプラグインであるプロバイダによって実装されます。プロバイダは通常、単一のクラウドまたはオンプレミスのインフラストラクチャプラットフォームを管理するためのリソースを提供します。

リソースを管理するためには、Terraformモジュールが必要とするプロバイダを指定する必要があります。また、ほとんどのプロバイダはリモートAPIにアクセスするために何らかの設定が必要であり、ルートモジュールでその設定を行なう必要があります。

### リソース引数

```
resource "aws_instance" "example" {
  ami           = "abc123"
  instance_type = "t3.micro"
}
```

リソースブロックのボディ内のほとんどの引数は、選択されたリソースタイプに固有のものです。リソースタイプのドキュメントには、どのような引数が利用できるか、またその値がどのようにフォーマットされるかが記載されています。

リソース引数の値には、式やその他のTerraform言語の動的機能を利用できます。

### リソースタイプのドキュメント

Terraformプロバイダには、リソースタイプとその引数を説明する独自のドキュメントがあります。

公開されているほとんどのプロバイダは、`Terraform Registry`で配布されており、そのドキュメントも提供されています。

## メタ引数

Terraform言語は、いくつかのメタ引数を定義しており、リソースの動作を変更するために任意のリソースタイプで使用できます。

- depends_on
    - リソースの依存関係を指定します
- count
    - 数に応じて複数リソースを作成します
- for_each
    - `map`や文字列の`set`に応じて複数リソースを作成します
- provider
    - デフォルト以外のプロバイダを選択するために使用します
- lifecycle
    - ライフサイクルのカスタマイズを行います
- provisioner and connection
    - リソースの作成後に追加のアクションを行なうためのものです

### depends_on

Terraformが自動的に推論できないリソースやモジュールの依存関係を扱うには、`depends_on`を使用します。

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
  # この表現は、ロールを参照しているため、
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

`count`は、Terraform言語で定義されたメタ引数です。モジュールやすべてのリソースタイプで使用できます。

`count`は、整数を指定することでリソースまたはモジュールのインスタンスをその数分だけ作成します。

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

`for_each`は、`Terraform` 言語で定義されたメタ引数です。モジュールやすべてのリソースタイプで使用できます。

`for_each`は、`map`または文字列の`set`を受け取り、その`map`または`set`内の各アイテムのインスタンスを作成します。

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

モジュールブロックでは、オプションの`providers`で、どのプロバイダ設定を適用するかを指定できます。

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

# providerは、デフォルト設定ではなく、
# エイリアスがvirginiaであるawsプロバイダ設定を選択します
resource "aws_instance" "example" {
  ami           = "ami-abc123"
  instance_type = "t3.micro"
  providers     = aws.virginia
}
```

### lifecycle

`lifecycle`は、リソースブロック内に存在するネストされたブロックです。ライフサイクルブロックとその内容はメタ引数であり、タイプを問わずすべてのリソースブロックで利用できます。

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
    - デフォルトでは、更新できないリソース引数を変更しなければならない場合、Terraformが代わりに既存オブジェクトを破壊してから、新規オブジェクトを作成します
- prevent_destroy
    - `true`に設定するとTerraformはリソースに関連付けられたインフラストラクチャオブジェクトを破壊ができません
- ignore_changes
    - 関連するリモートオブジェクトの更新を計画する際、Terraformが無視すべきリソース属性を指定します

## プロビジョナー

プロビジョナーは、サーバーやその他のインフラストラクチャオブジェクトのサービスを準備するため、ローカルマシンまたはリモートマシン上で特定のアクションをモデル化するために使用できます。

本ハンズオンでは使用しないため、詳細な説明は省きます。

- file
    - Terraformを実行しているマシンから、新しく作成されたリソースにファイルやディレクトリをコピーするために使用します
- local-exec
    - リソースが作成された後、Terraformを実行するマシン上で実行ファイルを起動します
- remote-exec
    - リモートリソースが作成された後、そのリソース上で実行ファイルを起動します
