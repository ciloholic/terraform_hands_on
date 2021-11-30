# ECRへのプッシュ

```
$ export AWS_ACCESS_KEY_ID=***
$ export AWS_SECRET_ACCESS_KEY=***
```

```
$ alias laws='docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY amazon/aws-cli'
$ laws --version
aws-cli/2.3.4 Python/3.8.8 Linux/5.10.47-linuxkit docker/x86_64.amzn.2 prompt/off
```

ECRの「プッシュコマンドの表示」からDockerイメージをプッシュする。
