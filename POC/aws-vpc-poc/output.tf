output vpc_id {
  value       = aws_vpc.vpc_1.id
  sensitive   = false
  description = "vpc id"
}

output public_subnets_id {
  value       = aws_subnet.public_subnets[*].id
  sensitive   = false
  description = "public subnets id"
}

output private_subnets_id {
  value       = aws_subnet.private_subnets[*].id
  sensitive   = false
  description = "private subnets id"
}