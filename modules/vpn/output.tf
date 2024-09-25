output "vpn_connection_id" {
  value = aws_vpn_connection.vpn.id
}

output "customer_gateway_id" {
  value = aws_vpn_connection.vpn.customer_gateway_id
}

output "vpn_gateway_id" {
  value = aws_vpn_connection.vpn.vpn_gateway_id
}

output "transit_gateway_id" {
  value = aws_vpn_connection.vpn.transit_gateway_id
}

output "type" {
  value = aws_vpn_connection.vpn.type
}

output "static_routes_only" {
  value = aws_vpn_connection.vpn.static_routes_only
}

output "tunnel1_address" {
  value = aws_vpn_connection.vpn.tunnel1_address
}

output "tunnel1_cgw_inside_address" {
  value = aws_vpn_connection.vpn.tunnel1_cgw_inside_address
}

output "tunnel1_vgw_inside_address" {
  value = aws_vpn_connection.vpn.tunnel1_vgw_inside_address
}

output "tunnel1_preshared_key" {
  value     = aws_vpn_connection.vpn.tunnel1_preshared_key
  sensitive = true
}

output "tunnel2_address" {
  value = aws_vpn_connection.vpn.tunnel2_address
}

output "tunnel2_cgw_inside_address" {
  value = aws_vpn_connection.vpn.tunnel2_cgw_inside_address
}

output "tunnel2_vgw_inside_address" {
  value = aws_vpn_connection.vpn.tunnel2_vgw_inside_address
}

output "tunnel2_preshared_key" {
  value     = aws_vpn_connection.vpn.tunnel2_preshared_key
  sensitive = true
}

output "routes" {
  value = aws_vpn_connection.vpn.routes
}

output "local_ipv4_network_cidr" {
  value = aws_vpn_connection.vpn.local_ipv4_network_cidr
}

output "remote_ipv4_network_cidr" {
  value = aws_vpn_connection.vpn.remote_ipv4_network_cidr
}

output "tags" {
  value = aws_vpn_connection.vpn.tags
}
