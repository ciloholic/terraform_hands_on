# WordPress のロググループを設定する
resource "aws_cloudwatch_log_group" "wordpress" {
  name              = "${local.service_config.name}-${local.service_config.env}-wordpress"
  retention_in_days = 30
}
