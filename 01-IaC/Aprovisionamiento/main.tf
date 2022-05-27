terraform {

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "terraform-state07" {
  bucket = "terraform-state07"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state07" {
     bucket = aws_s3_bucket.terraform-state07.id

     rule {
         apply_server_side_encryption_by_default {
           sse_algorithm = "AES256"
         }
     }   
 }

resource "aws_s3_bucket_versioning" "terraform-state07" {
  bucket = aws_s3_bucket.terraform-state07.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "terraform-state07" {
  bucket = aws_s3_bucket.terraform-state07.id
  acl =  "private"
}


resource "aws_dynamodb_table" "terraform-locks" {
  name = "terraform-state-locking"
  lifecycle {
    create_before_destroy = false
  }
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}