vpc_name = "demo-vpc-custom"
vpc_cidr = "192.168.0.0/16"
enable_dns_support = true
enable_dns_hostnames = true
availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
total_subnets_count = 4
map_public_ip_on_launch = true
public_subnets_count = 3
private_subnets_count = 1