# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.exchvpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.exchvpc.cidr_block
}

# Subnet Outputs
output "subnet_exch_id" {
  description = "The ID of the exch subnet"
  value       = aws_subnet.sub-exch.id
}

output "subnet_aff_id" {
  description = "The ID of the AFF subnet"
  value       = aws_subnet.sub-aff.id
}

# EC2 Instance Outputs
output "web_server_id" {
  description = "The ID of the EC2 web server instance"
  value       = aws_instance.web_server.id
}

output "web_server_private_ip" {
  description = "The private IP address of the EC2 web server instance"
  value       = aws_instance.web_server.private_ip
}


# Network Load Balancer Outputs
output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}


output "nlb_arn" {
  description = "The ARN of the Network Load Balancer"
  value       = aws_lb.nlb.arn
}

# Target Group Output
output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.tg.arn
}

# Transit Gateway Outputs
output "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.id
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.arn
}

# NAT Gateway Output
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.PublicNatGW-AFF.id
}

# VPC Endpoint Outputs
output "vpc_endpoint_ec2messages_id" {
  description = "The ID of the EC2 Messages VPC Endpoint"
  value       = aws_vpc_endpoint.ec2messages.id
}

/*# IAM Role Output
output "ssm_role_arn" {
  description = "The ARN of the IAM role for Session Manager"
  value       = aws_iam_role.ssm_role.arn
}
*/

output "ssm_instance_profile_name" {
  description = "The name of the instance profile for Session Manager"
  value       = aws_iam_instance_profile.ssm_instance_profile.name
}
