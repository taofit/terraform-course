terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "terraform"
}

variable "application_bucket" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "function_name" {
  type = string
}

data "aws_caller_identity" "current" {}



resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

resource "aws_iam_policy" "well_structured" {
  name        = "application-specific-policy"
  description = "Policy for application with specific resource access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          "arn:aws:s3:::${var.application_bucket}",
          "arn:aws:s3:::${var.application_bucket}/*"
        ]
      },
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:*"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:*"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}:*"
      },
      {
        Sid    = "Route53Access"
        Effect = "Allow"
        Action = [
          "route53:*"
        ]
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Sid = "IAMAccess"
        Effect = "Allow"
        Action = [
          "iam:*"
        ]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/application-specific-policy"
      }
    ]
  })
}
