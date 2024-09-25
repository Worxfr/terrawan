terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "${var.main_region}"  # Set your primary region
}

provider "aws" {
  region = "us-east-1"  
  alias = "shareregion"
}

resource "aws_networkmanager_global_network" "global_network" {
  description = "Global Network ${var.name}"

  tags = {
    Name = "CloudWAN-Global-Network-${var.name}"
  }
}

resource "aws_networkmanager_core_network" "core_network" {
  global_network_id = aws_networkmanager_global_network.global_network.id
  description       = "Core Network for Cloud WAN${var.name}"

  tags = {
    Name = "CloudWAN-Core-Network-${var.name}"
  }
}

resource "aws_networkmanager_core_network_policy_attachment" "policy_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = jsonencode({
    version = "2021.12"
    core-network-configuration = {
      asn-ranges = ["64512-65534"]
      edge-locations =[for region in var.list_of_regions : { location = region }]
    }

    segments = [
      { name = "SegA", require-attachment-acceptance = true  },
      { name = "SegAVPN", require-attachment-acceptance = true },
      { name = "SegB", require-attachment-acceptance = true },
      { name = "SegBVPN", require-attachment-acceptance = true  }
    ]
    segment-actions = [
    {
      action = "share",
      mode =  "attachment-route",
      segment =  "SegA",
      share-with = [
        "SegAVPN",
        "SegB",
      ]
    },
    {
      action = "share",
      mode =  "attachment-route",
      segment =  "SegB",
      share-with = [
        "SegBVPN",
        "SegA"
      ]
    },
    {
      action = "share",
      mode =  "attachment-route",
      segment =  "SegBVPN",
      share-with = [
        "SegB"
      ]
    },
    {
      action = "share",
      mode =  "attachment-route",
      segment =  "SegAVPN",
      share-with = [
        "SegA"
      ]
    }
  ],
    attachment-policies = [
      {
        rule-number     = 100
        condition-logic = "or"
        conditions = [
          {
            type     = "any"
          }
        ]
        action = {
          association-method = "tag"
          tag-value-of-key   = "CWAttach"
        }
      }
    ]
  })
}

# Create a Resource Share
resource "aws_ram_resource_share" "core_network_share" {
  name                      = "cloud-wan-core-network-share"
  allow_external_principals = true
  provider = aws.shareregion

  tags = {
    Name = "CloudWAN-Core-Network-Share"
  }
}

# Associate the Core Network with the Resource Share
resource "aws_ram_resource_association" "core_network_association" {
  provider = aws.shareregion
  resource_arn       = aws_networkmanager_core_network.core_network.arn
  resource_share_arn = aws_ram_resource_share.core_network_share.arn
}
