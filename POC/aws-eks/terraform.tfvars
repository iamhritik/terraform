cluster_name    = "demo-cluster"
cluster_version = "1.27"
# eks_cluster_logging = {
#   log_types = ["api", "audit"]
#   retentionPeriod = "3"
# }
eks_cluster_addons = {
  kube-proxy = {
    most_recent = true
  }
  vpc-cni = {
    most_recent = true
  }
}
# eks_cluster_addons_timeouts = {
#   create = "30m"
#   update = "30m"
#   delete = "30m"
# }
vpc_id = "vpc-0197ecae0bf849e96"
subnets_id = ["subnet-05740574ff360dd68","subnet-03fee4c190dede2da"]
#private_access = false
public_access      = true
public_access_cidr = ["0.0.0.0/0"]
#security_group_ids = 
service_ipv4_cidr = "10.100.0.0/16"
ip_family         = "ipv4"

#nodegroup variables
eks_nodegroup_name = "demo-cluster-nodegroup-1"
#nodegroup_version = ""
#ami_type           = "AL2_x86_64"
#release_version = "1.24.13-20230607"
capacity_type  = "SPOT"
disk_size      = 10
instance_types = ["t3a.small"]
nodegroup_labels = {
  testing = "terraform"
}
# launch_template = {
#     id = ""
#     version = ""
# }
remote_access = {
  ec2_ssh_key = "opstree"
}
#remote_access_security_group_id = 
# taints = {
#   dedicated = {
#     key    = "testing"
#     value  = "terraform"
#     effect = "NO_SCHEDULE"
#   }
# }
nodegroup_desired_size = 2
nodegroup_max_size     = 3
nodegroup_min_size     = 2
update_config = {
  max_unavailable_percentage = 20
}
timeouts = {
  create = "30m"
  update = "30m"
  delete = "30m"
}
#tags = {}