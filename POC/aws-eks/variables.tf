variable "cluster_name" {
  type        = string
  default     = "cluster-1"
  description = "EKS cluster name"
}

variable "cluster_version" {
  type        = string
  default     = null
  description = "EKS cluster version"
}

variable "eks_cluster_logging" {
  type        = any
  default     = null
  description = "eks cluster logging types [api,audit,authenticator,controllerManager,scheduler] & retentionPeriod(default - 7d)"
}

variable "eks_cluster_addons" {
  description = "EKS cluster addon configurations to enable for the cluster."
  type        = any
  default     = {}
}

variable "eks_cluster_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster addons"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC ID"
}

variable "subnets_id" {
  type        = list(string)
  default     = null
  description = "Subnet ID to create EKS Cluster and Nodegroups"
}
variable "private_access" {
  type        = bool
  default     = false
  description = "EKS cluster private_access"
}

variable "public_access" {
  type        = bool
  default     = true
  description = "EKS cluster public_access"
}

variable "public_access_cidr" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "EKS cluster public_access CIDR"
}

variable "security_group_ids" {
  type        = list(any)
  default     = null
  description = "EKS cluster control plane security group"
}

variable "service_ipv4_cidr" {
  type        = string
  default     = "172.20.0.0/16"
  description = "EKS cluster CIDR block to assign Kubernetes pod and service IP addresses from"
}

variable "ip_family" {
  type        = string
  default     = "ipv4"
  description = "EKS cluster IP family used to assign Kubernetes pod and service addresses"
}

#nodegroup variables
variable "eks_nodegroup_name" {
  type        = string
  default     = null
  description = "EKS nodegroup name"
}

variable "nodegroup_version" {
  type        = string
  default     = null
  description = "EKS nodegroup version"
}

variable "ami_type" {
  type        = string
  default     = null
  description = "EKS nodegroup ami_type, Valid values are AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM, BOTTLEROCKET_ARM_64, BOTTLEROCKET_x86_64"
}

variable "release_version" {
  type        = string
  default     = null
  description = "EKS nodegroup AMI release_version"
}

variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "EKS nodegroup capacity_type - ON_DEMAND(default) or SPOT"
}

variable "disk_size" {
  type        = number
  default     = 50
  description = "EKS nodegroup node disk size"
}

variable "instance_types" {
  type        = list(any)
  default     = ["t3.medium"]
  description = "EKS nodegroup instance_types"
}

variable "nodegroup_labels" {
  type        = map(string)
  default     = null
  description = "EKS nodegroup labels"
}

variable "launch_template" {
  type        = map(string)
  default     = {}
  description = "EKS nodegroup launch template"
}

variable "remote_access" {
  type        = any
  default     = {}
  description = "EKS nodegroup remote access ssh key"
}

variable "taints" {
  type        = any
  default     = {}
  description = "EKS nodegroup taint key"
}

variable "nodegroup_desired_size" {
  type        = number
  default     = 1
  description = "EKS nodegroup desired size"
}

variable "nodegroup_max_size" {
  type        = number
  default     = 2
  description = "EKS nodegroup max size"
}

variable "nodegroup_min_size" {
  type        = number
  default     = 0
  description = "EKS nodegroup min size"
}

variable "update_config" {
  type = map(string)
  default = {
    max_unavailable_percentage = 33
  }
  description = "EKS nodegroup max percentage and no of unavailable worker nodes during node group update"
}

variable "timeouts" {
  type        = map(string)
  default     = {}
  description = "EKS nodegroup timeouts"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "EKS nodegroup tags"
}
