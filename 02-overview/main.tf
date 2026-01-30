terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tfdemo-tao"
    key            = "02-overview/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfdemo-tao-state"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}

resource "aws_instance" "example" {
  ami           = "ami-011899242bb902164" # Ubuntu 20.04 LTS // us-east-1
  instance_type = "t2.micro"
}

# Test resource - create a simple S3 bucket

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-terraform-test-bucket-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 10
}

output "bucket_name" {
  value = aws_s3_bucket.test_bucket.bucket
}

