resource "aws_customer_gateway" "test" {
  bgp_asn    = 65000
  ip_address = var.ipcgw
  type       = "ipsec.1"
}
resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = aws_customer_gateway.test.id
  type                = "ipsec.1"
  tags = {
    Name = "vpn-${var.name}"
  }
}

resource "aws_networkmanager_site_to_site_vpn_attachment" "test" {
  core_network_id    = var.core_network_id
  vpn_connection_arn = aws_vpn_connection.vpn.arn
  tags = {
    CWAttach = "${var.segment}"
  }
}

resource "aws_networkmanager_attachment_accepter" "test" {
  attachment_id   = aws_networkmanager_site_to_site_vpn_attachment.test.id
  attachment_type = aws_networkmanager_site_to_site_vpn_attachment.test.attachment_type
  depends_on = [ aws_networkmanager_site_to_site_vpn_attachment.test ]
}