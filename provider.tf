provider "aws" {
    region = var.aws_region
}


terraform {
  backend "s3" {
      bucket = "sharks-terra-backend-file"
      key = "terraform.tfstate"
      region = "us-east-2"
      dynamodb_table = "terraform"
  }
}
