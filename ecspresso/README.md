# インストール

```
$ brew install kayac/tap/ecspresso
```

# Fargateへのデプロイ

```
$ export AWS_ACCOUNT_ID=***
$ export ECR_IMAGE=$AWS_ACCOUNT_ID.dkr.ecr.ap-northeast-1.amazonaws.com/tsp-dev-flask:latest
```

```
$ ecspresso status
$ ecspresso verify
$ ecspresso deploy --tasks=1
$ ecspresso deploy --tasks=-1 --skip-task-definition --dry-run
```
