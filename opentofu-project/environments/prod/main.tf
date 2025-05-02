provider "aws" {
  region = "us-west-2"
}

module "example" {
  source = "../../modules/example"

  # Add any production-specific variables here
}

resource "aws_s3_bucket" "prod_bucket" {
  bucket = "my-prod-bucket"
  acl    = "private"

  tags = {
    Environment = "production"
  }
}