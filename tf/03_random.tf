# Aurora のパスワードを生成
resource "random_password" "aurora_master_password" {
  length  = 16
  special = false
}
