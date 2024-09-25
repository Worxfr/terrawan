# Output the Core Network ID
output "core_network_id" {
  description = "The ID of the Cloud WAN Core Network"
  value       = aws_networkmanager_core_network.core_network.id
}

# Output the Core Network ARN
output "core_network_arn" {
  description = "The ARN of the Cloud WAN Core Network"
  value       = aws_networkmanager_core_network.core_network.arn
}

# Output the Global Network ID
output "global_network_id" {
  description = "The ID of the Global Network associated with the Core Network"
  value       = aws_networkmanager_core_network.core_network.global_network_id
}

# Output the Core Network State
output "core_network_state" {
  description = "The current state of the Core Network"
  value       = aws_networkmanager_core_network.core_network.state
}

# Output the Core Network Segments
output "core_network_segments" {
  description = "The segments defined in the Core Network"
  value       = aws_networkmanager_core_network.core_network.segments
}

# Output the Core Network Edge Locations
output "core_network_edges" {
  description = "The edge locations of the Core Network"
  value       = aws_networkmanager_core_network.core_network.edges
}

# Output the Core Network Creation Time
output "core_network_created_at" {
  description = "The timestamp when the Core Network was created"
  value       = aws_networkmanager_core_network.core_network.created_at
}

# Output the Core Network Description
output "core_network_description" {
  description = "The description of the Core Network"
  value       = aws_networkmanager_core_network.core_network.description
}

# Output the Core Network Policy Document
output "core_network_policy" {
  description = "The policy document applied to the Core Network"
  value       = aws_networkmanager_core_network_policy_attachment.policy_attachment.policy_document
}
