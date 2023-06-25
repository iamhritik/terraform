module "vpc_creation" {
  source                  = "../aws-vpc-poc"
  vpc_name                = "hitesh-vpc-custom"
  vpc_cidr                = "192.168.0.0/16"
  enable_dns_support      = true
  enable_dns_hostnames    = true
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
  total_subnets_count     = 4
  map_public_ip_on_launch = true
  public_subnets_count    = 2
  private_subnets_count   = 2
  # enable_vpc_logging = false
  # destination_type   = "s3"
  # log_format = 
  # iam_role_arn = 
  # traffic_type             = "ACCEPT"
  # max_aggregation_interval = 60
  # cloudwatch_log_group_name = 
  # logging_bucket_name = "demo-vpc-loggingtestbucket1234"
  # flow_log_file_format = "plain-test"
  # flow_log_hive_compatible_partitions = true
  # flow_log_per_hour_partition = true
}