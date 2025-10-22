provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "sctp-ce11-tfstate"
    key    = "jibin-s3-tf-ci.tfstate" #Change this
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = "jibin.tan" #if your name contains any invalid characters like “.”, hardcode this name_prefix value = <YOUR NAME>
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
    bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}

resource "aws_s3_bucket_public_access_block" "s3_tf_block" {
  bucket                  = aws_s3_bucket.s3_tf.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

