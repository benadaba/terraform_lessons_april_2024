resource "random_integer" "priority" {
  min = 1
  max = 50000
  
}

resource "aws_s3_bucket" "photoshoot_bucket" {
  bucket = "photoshoot-bucket-${random_integer.priority.result}-${var.region}"
  
  tags = {
    Name        = "photoshoot_bucket_tf"
    Environment = "production"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
 count = var.environment == "prod" ? 1 : 0

  bucket = aws_s3_bucket.photoshoot_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}



data "aws_iam_policy_document" "allow_access_from_another_account" {
  
  dynamic statement {

    for_each = var.environment == "prod" ? [1] : []

    content {
        principals {
        type        = "AWS"
        identifiers = ["612773348282"]
        }

        actions = [
        "s3:GetObject",
        "s3:ListBucket",
        ]

        resources = [
        aws_s3_bucket.photoshoot_bucket.arn,
        "${aws_s3_bucket.photoshoot_bucket.arn}/*",
        ]
    }

  }
}

# # aws_s3_bucket.photoshoot_bucket
# # aws_s3_bucket_policy.allow_access_from_another_account