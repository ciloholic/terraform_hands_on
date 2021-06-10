# Terraform の開発環境構築

## tfenv の導入

Terraformは、2021/6/8に`v1.0.0`に到達しました。

頻繁にバージョンが上がるため、`tfenv`でTerraformのバージョンを切り替えられるようにします。

すでに `homebrew`を導入している場合は`brew install tfenv`で導入ができます。

`.terraform-version`にバージョンを指定している場合は、暗黙的に指定されたバージョンが使用されます。

```
$ brew install tfenv
$ echo "1.0.0" > .terraform-version
$ tfenv install
```

問題なく導入ができている場合は、下記のようにTerraformのバージョンが表示されます。

```
$ terraform -v
Terraform v1.0.0
on darwin_amd64
```
