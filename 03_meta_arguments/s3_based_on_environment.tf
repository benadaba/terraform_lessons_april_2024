resource "aws_s3_bucket" "photoshoot_bucket" {
  count = length(var.environment_suffix)
  bucket = "photoshoot-bucket-${count.index}"
  
  tags = {
    Name        = "photoshoot_bucket_tf"
    Environment = "production"
  }
}




resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
#  count = var.environment == "dev" ? 1 : 0
 count  = var.environment == "dev" || var.environment == "staging"  ?  length(var.environment_suffix) : 0
  bucket = aws_s3_bucket.photoshoot_bucket[count.index].id
  policy = data.aws_iam_policy_document.allow_access_from_another_account[count.index].json
}



data "aws_iam_policy_document" "allow_access_from_another_account" {
  count  = var.environment == "dev" || var.environment == "staging"  ?  length(var.environment_suffix) : 0

  dynamic statement {

    for_each = var.environment == "dev" || var.environment == "staging"  ? [1] : []

    content {
        principals {
        type        = "AWS"
        identifiers = ["612773348282"]
        }

        actions = [
        "s3:*",
        ]

        resources = [
        aws_s3_bucket.photoshoot_bucket[count.index].arn,
        "${aws_s3_bucket.photoshoot_bucket[count.index].arn}/*",
        ]
    }

  }

    statement {
            
            principals {
            type        = "AWS"
            identifiers = ["612773348282"]
            }

            actions = [
            "s3:GetObject",
            "s3:ListBucket",
            ]

            resources = [
            aws_s3_bucket.photoshoot_bucket[count.index].arn,
            "${aws_s3_bucket.photoshoot_bucket[count.index].arn}/*",
            ]
    }

}


# aws_s3_bucket.photoshoot_bucket
# aws_s3_bucket_policy.allow_access_from_another_account