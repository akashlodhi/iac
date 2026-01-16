resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.acl

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# ✅ Block public access (correct way)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}


module "ecs_cluster" {
  source       = "./modules/ecs"
  cluster_name = var.ecs_cluster_name
  environment  = var.environment
}
