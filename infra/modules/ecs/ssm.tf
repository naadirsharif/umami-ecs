## SSM Paramater -> connect with database

resource "aws_ssm_parameter" "db_connection_string" {
  name  = "/umami/db/connection_string"
  type  = "SecureString"
  value = var.db_string
  tags  = var.tags
}