# データソース

データソースは、Terraform構成の他の場所で使用するためにデータを取得できます。

## タグ名「test」でデータソースを抽出し、取得する

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
