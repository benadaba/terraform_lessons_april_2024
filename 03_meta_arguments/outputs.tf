output "s3-bucket-name"{
    value = aws_s3_bucket.photoshoot_bucket[*].bucket
}

output "s3-bucket-arn"{
    value = [ for bkt in aws_s3_bucket.photoshoot_bucket: bkt.arn ]
}