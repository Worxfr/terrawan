terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      //version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "corenetwork" {
  source = "./modules/corenetwork"
  name = "MyTEST"
}

module "ipam" {
  source = "./modules/ipam"
  name = "MyTEST"
}

module "B"{
    source = "./modules/templateaffiliatevpc"
    core_network_arn = module.corenetwork.core_network_arn
    core_network_id = module.corenetwork.core_network_id
    //ipam_pool_id = module.ipam.ipam_pool_id
    segment = "SegB"
    name = "SegB"
    ofccidr = "100.64.0.0/24"
    pool_map = module.ipam.poolmap
    //poolchild = module.ipam.poolchild
    depends_on = [ module.corenetwork, module.ipam  ]
}

module "A"{
    source = "./modules/templateaffiliatevpc"
    core_network_arn = module.corenetwork.core_network_arn
    core_network_id = module.corenetwork.core_network_id
    //ipam_pool_id = module.ipam.ipam_pool_id
    segment = "SegA"
    name = "SegA"
    ofccidr = "100.64.0.0/24"
    pool_map = module.ipam.poolmap
    //poolchild = module.ipam.poolchild
    depends_on = [ module.corenetwork, module.ipam ]
}

module "segavpn" {
  source = "./modules/vpn"
  core_network_id = module.corenetwork.core_network_id
  segment = "SegAVPN"
  name = "A"
  ipcgw = var.ipcgw
  depends_on = [ module.corenetwork ]
}

module "segbvpn" {
  source = "./modules/vpn"
  core_network_id = module.corenetwork.core_network_id
  segment = "SegBVPN"
  name = "B"
  ipcgw = var.ipcgw
  depends_on = [ module.corenetwork ]
}
