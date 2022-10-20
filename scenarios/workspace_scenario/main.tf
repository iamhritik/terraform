resource "aws_s3_bucket" "terraform-state" {
 bucket = "tothenewaccount"
 acl    = "private"

 versioning {
   enabled = true
 }

}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}



resource "aws_dynamodb_table" "terraform-state" {
 name           = "terraform-state"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}

#-------------------------
resource "aws_instance" "instance1" {
    ami                    = "ami-006d3995d3a6b963b"
    instance_type          = "t2.micro"
    key_name               = "ttn"
    subnet_id              = "subnet-01a2927ff29ebfbb8"
    vpc_security_group_ids = ["sg-0edde130a81dec1b9"]
    availability_zone      = "ap-south-1b"

    root_block_device {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 10
        volume_type           = "gp3"
        tags = {
            Name = "web-server-root-vol"
            }
    }
    tags = {
        Name       = "instance1-testing-workspace"
        managed_by = "terraform-managed"
    }
}