terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

   backend "s3" {
	bucket = "meu-bucket-tfstate-local"
	key    = "01-bootstrap/terraform.tfstate"
	region = "us-east-1"
	dynamodb_table = "meu-lock-table-local"
	endpoints = { 
	s3 = "http://localhost:4566"
	dynamodb = "http://localhost:4566"
	sts = "http://localhost:4566"
	}
	use_path_style = true
	skip_credentials_validation = true
	skip_metadata_api_check = true
   	skip_region_validation = true
	skip_requesting_account_id = true
 }
}

provider "aws" {
  region = "us-east-1"
  access_key = "test"
  secret_key = "test"
  skip_credentials_validation = true
  skip_metadata_api_check = true
  skip_requesting_account_id = true
  s3_use_path_style = true

  endpoints {
    s3 = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    sts = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "meu-bucket-tfstate-local"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "meu-lock-table-local"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}