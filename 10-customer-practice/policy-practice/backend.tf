terraform {
  backend "s3" {
    bucket         = "devops-directive-tf-tao-state" # REPLACE WITH YOUR BUCKET NAME
    key            = "03-basics/import-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
    profile        = "terraform"
  }
}
