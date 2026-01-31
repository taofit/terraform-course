terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "terraform"
}

variable "aws_region" {
  type = string
}

variable "application_bucket" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

resource "aws_s3_bucket" "terraform_app_bucket" {
  bucket        = var.application_bucket
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_app_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_app_bucket_crypto_conf" {
  bucket        = aws_s3_bucket.terraform_app_bucket.bucket 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_app_bucket.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
