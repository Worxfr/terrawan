terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      //version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Set your desired region
}

# Create a Resource Share
resource "aws_ram_resource_share" "core_network_share" {
  name                      = "cloud-wan-core-network-share"
  allow_external_principals = true

  tags = {
    Name = "CloudWAN-Core-Network-Share"
  }
}

# Associate the Core Network with the Resource Share
resource "aws_ram_resource_association" "core_network_association" {
  resource_arn       = var.cnshare
  resource_share_arn = aws_ram_resource_share.core_network_share.arn
}

# Share the Core Network with another AWS Account
resource "aws_ram_principal_association" "share_with_account" {
  principal          = "${var.accountid}"  # Replace with the AWS account ID you want to share with
  resource_share_arn = aws_ram_resource_share.core_network_share.arn
}
