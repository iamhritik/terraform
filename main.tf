module "web-server" {
    source = "/home/ubuntu/terraform/modules/web-server"
    security_group_name = "web-server-demo-sg"
    instance_name = "web-server-demo"
}

output "instance_id" {
    value = module.web-server.instance_name
    description = "ec2 instance id"
}