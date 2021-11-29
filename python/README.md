# インストール

```
$ brew install kayac/tap/ecspresso
```

# ECRへのプッシュ

```
$ cd python
$ export AWS_ACCESS_KEY_ID=***
$ export AWS_SECRET_ACCESS_KEY=***
$ alias laws='docker run --rm -it -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY amazon/aws-cli'
$ laws --version
aws-cli/2.3.4 Python/3.8.8 Linux/5.10.47-linuxkit docker/x86_64.amzn.2 prompt/off
```

# Fargateへのデプロイ

```
$ cd python/ecspresso
$ export AWS_ACCOUNT_ID=***
$ export ECR_IMAGE=$AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-1.amazonaws.com/tsp-dev-flask:latest
```

```
$ ecspresso status --config ecspresso.yaml
$ ecspresso --config ecspresso.yaml verify
$ ecspresso deploy --config ecspresso.yaml --tasks=1
$ ecspresso deploy --config ecspresso.yaml --tasks=-1 --skip-task-definition --dry-run
```
