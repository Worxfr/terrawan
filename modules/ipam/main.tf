terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "${var.region}"  # Set your primary region
}


# Create the IPAM
resource "aws_vpc_ipam" "main" {
  dynamic operating_regions {
      for_each = local.all_ipam_regions
      content {
        region_name = operating_regions.value
      }
    }

  tags = {
    Name = "${var.name}-ipam"
  }
}

# Create the top-level pool
resource "aws_vpc_ipam_pool" "top_level" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  //locale         = var.region

  tags = {
    Name = "${var.name}-top-level-pool"
  }
}

# Allocate the CIDR to the child pool
resource "aws_vpc_ipam_pool_cidr" "root_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  cidr         = var.ipamcidr
}

# Create the child pool with the specified CIDR
resource "aws_vpc_ipam_pool" "child" {
  count = 2
  address_family      = "ipv4"
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  locale              = element(var.ipam_regions, count.index)
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  tags = {
    Name = "${var.name}-child-pool-${var.ipam_regions[count.index]}"
  }
}

# Allocate the CIDR to the child pool
resource "aws_vpc_ipam_pool_cidr" "child_cidr" {
  count = 2
  ipam_pool_id = aws_vpc_ipam_pool.child[count.index].id
  cidr         = cidrsubnet(var.ipamcidr, 6, count.index)
  depends_on = [ aws_vpc_ipam_pool_cidr.root_cidr ]
}

# Create a Resource Share
resource "aws_ram_resource_share" "ipam_share" {
  name                      = "${var.name}-poolshare"
  allow_external_principals = true

  tags = {
    Name = "${var.name}-poolshare"
  }
}

# Associate the Core Network with the Resource Share
resource "aws_ram_resource_association" "ipam_association" {
  count = length(aws_vpc_ipam_pool.child)
  resource_arn       = aws_vpc_ipam_pool.child[count.index].arn
  resource_share_arn = aws_ram_resource_share.ipam_share.arn
}
