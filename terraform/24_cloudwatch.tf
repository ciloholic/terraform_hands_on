# Flask のロググループを設定する
resource "aws_cloudwatch_log_group" "flask" {
  name              = "${local.service_config.name}-${local.service_config.env}-flask"
  retention_in_days = 30
}
