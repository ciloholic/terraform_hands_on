data "aws_iam_policy_document" "fargate_execution_policy_document" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# タスクに付与する権限を作成する
resource "aws_iam_role" "fargate_execution_role" {
  name               = "${local.service_config.prefix}-fargate-execution-role"
  assume_role_policy = data.aws_iam_policy_document.fargate_execution_policy_document.json

  tags = {
    Name = "${local.service_config.prefix}-fargate-execution-role"
  }
}

data "aws_iam_policy_document" "fargate_ssm_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]
    resources = [
      "arn:aws:ssm:${local.aws_config.region}:${local.aws_config.aws_account_id}:parameter/${local.service_config.name}/${local.service_config.env}/*",
      "arn:aws:secretsmanager:${local.aws_config.region}:${local.aws_config.aws_account_id}:secret/${local.service_config.name}/${local.service_config.env}/*",
      aws_kms_key.example.arn
    ]
  }
}

resource "aws_iam_policy" "fargate_ssm_policy" {
  name   = "${local.service_config.prefix}-fargate-ssm-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.fargate_ssm_policy_document.json
}

resource "aws_iam_role_policy" "fargate_ssm_role_policy" {
  name   = "${local.service_config.prefix}-fargate-ssm-role-policy"
  role   = aws_iam_role.fargate_execution_role.id
  policy = aws_iam_policy.fargate_ssm_policy.policy
}

# タスクロールに他サービスへの権限を付与する
resource "aws_iam_role_policy_attachment" "fargate_task_role_policy_attachment" {
  role       = aws_iam_role.fargate_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
