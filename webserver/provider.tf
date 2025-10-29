terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = "xxxxx"
  secret_key = "xxxxx"
}
