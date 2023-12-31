# resource "aws_s3_bucket" "s3-bucket" {
#   bucket = var.s3_bucket
#   acl    = "private"

#   tags = {
#     Name        = "${var.Project}"
#     Environment = "dev"
#   }
# }

# resource "aws_s3_bucket_versioning" "s3-bucket-versioning" {
#   bucket = aws_s3_bucket.s3-bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "dynamodb-lock-table" {
#   name         = var.dynamodb_table_name
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name        = "${var.Project}-dyanmodb-table"
#     Environment = "dev"
#   }
# }
