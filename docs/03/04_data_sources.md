# データソース

データソースは、`Terraform` 構成の他の場所で使用する為にデータを取得することが出来ます。

## タグ名「test」でデータソースをフィルタリングし、取得する

```
data "aws_vpc" "example" {
  filter {
    name   = "tag:Name"
    values = ["test"]
  }
}
```

## 取得したデータソースを参照する

```
data "aws_route_table" "example" {
  vpc_id = data.aws_vpc.example.id

  # ...
}
```
