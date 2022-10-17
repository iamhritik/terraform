resource "aws_instance" "testing" {
    ami                                  = "ami-062df10d14676e201"
    associate_public_ip_address          = true
    availability_zone                    = "ap-south-1a"
    instance_type                        = "t2.micro"
    key_name                             = "ttn"
    subnet_id                            = "subnet-0acec19483e2989ef"
    tags                                 = {
        "Name" = "testing-server"
    }
    tenancy                              = "default"
    vpc_security_group_ids               = [
        "sg-0a8554057bfdb46a9",
    ]
    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
        instance_metadata_tags      = "disabled"
    }
    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 100
        tags                  = {}
        throughput            = 0
        volume_size           = 8
        volume_type           = "gp2"
    }
}