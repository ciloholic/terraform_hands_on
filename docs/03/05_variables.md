# 変数

## 入力変数

Terraformでは、変数宣言のために以下のオプション引数を定義しています。

- default
    - 変数のデフォルト値を指定します
- type
    - 変数の型を指定します
- description
    - 変数のドキュメントを指定します
- validation
    - 検証ルールを定義するブロックで、通常は型の制約に追加されて使用されます
- sensitive
    - 変数の標準出力を制限します

```
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  default     = "ami-abc123"
  sensitive   = true

  validation {
    condition     = can(regex("^ami-", var.image_id))
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
```

## ローカル値

関連するローカル値の設定は、1つのローカルブロックにまとめて宣言できます。

```
locals {
  service_name = "forum"
  owner        = "Community Team"
}
```

ローカル値の表現は、リテラル定数に限らず、変数やリソース属性など、モジュール内の他の値を参照して変換や結合を行なうこともできます。

```
locals {
  # EC2インスタンスのIDをマージ
  instance_ids = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
}

locals {
  # すべてのリソースに付与される共通タグ
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }
}
```
