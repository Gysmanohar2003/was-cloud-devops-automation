terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.90" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "state_bucket_prefix" {
  type    = string
  default = "cloud-devops-tfstate-"
}
resource "random_id" "suffix" { byte_length = 4 }
resource "aws_s3_bucket" "state" { 
  bucket = "${
    var.state_bucket_prefix
  }${
    random_id.suffix.hex
  }" 
}
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration { status = "Enabled" }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "legacy_lock" {
  name         = "cloud-devops-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
output "state_bucket" { value = aws_s3_bucket.state.bucket }
output "legacy_lock_table" { value = aws_dynamodb_table.legacy_lock.name }
