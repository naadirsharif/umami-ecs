resource "aws_s3_bucket" "tf-state" {
  bucket = var.s3_bucket_name
  bucket_namespace = "global"

  tags =  var.tags
}

resource "aws_s3_bucket_public_access_block" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}