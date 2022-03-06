data "aws_caller_identity" "account-id" {}

locals {
  current_account = data.aws_caller_identity.account-id.account_id
}

resource "aws_s3_bucket" "sharks_bucket" {
  bucket = var.s3_bucket
  acl    = "private"

  tags = {
    Name        = var.s3_bucket
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = "sharks-alb-access-logs-bucket12345"
  policy = data.template_file.sharks.rendered
  acl    = "private"

  tags = {
    Name        = "sharks-alb-access-logs-bucket12345"
    Environment = terraform.workspace
  }
}

data "template_file" "sharks" {
    template = file("scripts/iam/elb-access-logging.json")
    vars = {
        access_logs_bucket = "sharks-alb-access-logs-bucket12345"
        policy_account_id = local.current_account
    }
  
}
