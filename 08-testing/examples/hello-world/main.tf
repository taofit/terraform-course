terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "devops-directive-tf-tao-state"
    key            = "08-testing/examples/hello-world/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
    profile        = "terraform"

  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "terraform"
}


module "web_app" {
  source = "../../modules/hello-world"
}

output "instance_ip_addr" {
  value = module.web_app.instance_ip_addr
}

output "url" {
  value = "http://${module.web_app.instance_ip_addr}:8080"
}

output "instance_id" {
  value = module.web_app.instance_id
}
