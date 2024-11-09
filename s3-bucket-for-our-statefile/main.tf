terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-west-2"
}


resource "aws_s3_bucket" "statefile_bucket" {
  bucket = "tfstate-bucket-datapandas3"
  
  versioning {
    enabled = true
  }

  tags = {
    Name        = "My Terraform state bucket"
    Environment = "Dev"
  }
}


resource "aws_dynamodb_table" "db_for_state_locking" {
  name             = "terraform-lock"
  hash_key         = "LockID"
  read_capacity = 3
  write_capacity = 3

  attribute {
    name = "LockID"
    type = "S"
  }
  

  tags = {
      Name = "Table for terraform state locking"
  }
}