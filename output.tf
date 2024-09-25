output "VPN1tunnel1_address" {
  value = module.segavpn.tunnel1_address
}

output "VPN1tunnel1_cgw_inside_address" {
  value = module.segavpn.tunnel1_cgw_inside_address
}

output "VPN1tunnel1_vgw_inside_address" {
  value = module.segavpn.tunnel1_vgw_inside_address
}

output "VPN1tunnel1_preshared_key" {
  value     = module.segavpn.tunnel1_preshared_key
  sensitive = true
}

output "VPN1tunnel2_address" {
  value = module.segavpn.tunnel2_address
}

output "VPN1tunnel2_cgw_inside_address" {
  value = module.segavpn.tunnel2_cgw_inside_address
}

output "VPN1tunnel2_vgw_inside_address" {
  value = module.segavpn.tunnel2_vgw_inside_address
}

output "VPN1tunnel2_preshared_key" {
  value     = module.segavpn.tunnel2_preshared_key
  sensitive = true
}

output "VPN1routes" {
  value = module.segavpn.routes
}

output "VPN1local_ipv4_network_cidr" {
  value = module.segavpn.local_ipv4_network_cidr
}

output "VPN1remote_ipv4_network_cidr" {
  value = module.segavpn.remote_ipv4_network_cidr
}

output "VPN2tunnel1_address" {
  value = module.segbvpn.tunnel1_address
}

output "VPN2tunnel1_cgw_inside_address" {
  value = module.segbvpn.tunnel1_cgw_inside_address
}

output "VPN2tunnel1_vgw_inside_address" {
  value = module.segbvpn.tunnel1_vgw_inside_address
}

output "VPN2tunnel1_preshared_key" {
  value     = module.segbvpn.tunnel1_preshared_key
  sensitive = true
}

output "VPN2tunnel2_address" {
  value = module.segbvpn.tunnel2_address
}

output "VPN2tunnel2_cgw_inside_address" {
  value = module.segbvpn.tunnel2_cgw_inside_address
}

output "VPN2tunnel2_vgw_inside_address" {
  value = module.segbvpn.tunnel2_vgw_inside_address
}

output "VPN2tunnel2_preshared_key" {
  value     = module.segbvpn.tunnel2_preshared_key
  sensitive = true
}

output "VPN2routes" {
  value = module.segbvpn.routes
}

output "VPN2local_ipv4_network_cidr" {
  value = module.segbvpn.local_ipv4_network_cidr
}

output "VPN2remote_ipv4_network_cidr" {
  value = module.segbvpn.remote_ipv4_network_cidr
}

output "nlbA_dns_name" {
  value = module.A.nlb_dns_name
}

output "nlbB_dns_name" {
  value = module.B.nlb_dns_name
}
  
