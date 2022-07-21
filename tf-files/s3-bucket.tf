resource "aws_s3_bucket" "tf-lock-demo" {
  bucket = "tf-lock-demo"
  #prevent resources from accidental deletion
  # lifecycle {
  #   prevent_destroy = true
  # }

  versioning {
    enabled = true
  }
  tags = {
    Name = "demo-tf"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.tf-lock-demo.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}