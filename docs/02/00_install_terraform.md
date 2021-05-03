# Terraform の開発環境構築

## tfenv の導入

`Terraform` はまだ `v1` に到達しておらず頻繁に更新が入る為、`tfenv` で `Terraform` のバージョンを切り替えられるようにします。

既に `homebrew` を導入している場合は `brew install tfenv` で導入が出来ます。

`.terraform-version` にバージョンを指定している場合は、暗黙的に指定されたバージョンが使用されます。

```
$ brew install tfenv
$ echo "0.15.1" > .terraform-version
$ tfenv install
```

問題なく導入が出来ている場合は、下記のように `Terraform` のバージョンが表示されます。

```
$ terraform -v
Terraform v0.15.1
on darwin_amd64
```
