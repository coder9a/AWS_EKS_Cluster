aws_region          = "us-east-1"
capacity_type       = "ON_DEMAND"
instance_type       = ["t2.medium"]
ami_type            = "AL2_x86_64"
disk_size           = 20
s3_bucket           = "weber-s3-bucket"
dynamodb_table_name = "weber-dynamodb-lock-table"