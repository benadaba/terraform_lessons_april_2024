terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }

  backend "s3" {
    bucket = "tfstate-bucket-datapandas1"
    key = "terraform/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    region = "eu-west-2"
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

