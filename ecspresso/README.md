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
$ ecspresso status --config ecspresso.yaml
$ ecspresso --config ecspresso.yaml verify
$ ecspresso deploy --config ecspresso.yaml --tasks=1
$ ecspresso deploy --config ecspresso.yaml --tasks=-1 --skip-task-definition --dry-run
```
