resource "aws_s3_bucket" "S3_backup" {
  bucket = "that-bucket-s3-project"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_versioning" "backup_versioning" {
  bucket = aws_s3_bucket.S3_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}