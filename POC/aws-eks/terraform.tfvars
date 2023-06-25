cluster_name    = "demo-cluster"
cluster_version = "1.24"
#private_access = false
public_access      = true
public_access_cidr = ["0.0.0.0/0"]
#security_group_ids = 
service_ipv4_cidr = "10.100.0.0/16"
ip_family         = "ipv4"

#nodegroup variables
eks_nodegroup_name = "demo-cluster-nodegroup-1"
ami_type           = "AL2_ARM_64"
capacity_type      = "SPOT"
disk_size          = 60
instance_types     = ["t3a.small"]
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
taints = {
  dedicated = {
    key    = "testing"
    value  = "terraform"
    effect = "NO_SCHEDULE"
    }
}
nodegroup_desired_size = 2
nodegroup_max_size     = 2
nodegroup_min_size     = 1
update_config = {
  max_unavailable_percentage = 20
}
timeouts = {
  create = "30m"
  update = "30m"
  delete = "30m"
}
#tags = {}