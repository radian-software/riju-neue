terraform {
  backend "s3" {
    bucket         = "radian-tf-riju-neue"
    dynamodb_table = "radian-tf-riju-neue"
    key            = "state"
    region         = "us-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  tags = {
    Terraform       = "Managed by Terraform"
    BillingCategory = "RijuNeue"
  }
}

provider "aws" {
  region = "us-west-1"

  default_tags {
    tags = local.tags
  }
}
