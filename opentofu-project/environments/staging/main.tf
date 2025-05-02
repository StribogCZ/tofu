provider "aws" {
  region = "us-east-1"
}

module "example" {
  source = "../../modules/example"
}

resource "aws_s3_bucket" "staging_bucket" {
  bucket = "my-staging-bucket-${var.environment}"
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.staging_bucket.bucket
}