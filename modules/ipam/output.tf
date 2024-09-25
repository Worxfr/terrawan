# Output the IPAM and pool IDs
output "ipam_id" {
  value = aws_vpc_ipam.main.id
}

output "top_level_pool_id" {
  value = aws_vpc_ipam_pool.top_level.id
}

output "poolarnlist" {
  value = aws_vpc_ipam_pool.child[*].arn
}

output "poolmap" {
  value = zipmap( aws_vpc_ipam_pool.child[*].locale, aws_vpc_ipam_pool.child[*].id)
}

/*output "poolchild"{
  value = aws_vpc_ipam_pool.child[0]
}*/

output "poolarnmap" {
  value = zipmap( aws_vpc_ipam_pool.child[*].locale, aws_vpc_ipam_pool.child[*].arn)
}

# Output the IPAM Share association ID
output "ipam_share_arn" {
  description = "The ID of the IPAM"
  value       = aws_ram_resource_share.ipam_share.arn
}

# Output the Core Network Share ARN


output "ipam_share_association_arn" {
  description = "The ARN of the Pool share association"
  value       = aws_ram_resource_association.ipam_association[*].resource_arn
}
