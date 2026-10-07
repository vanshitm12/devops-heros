output "bucket_id" {
  description = "Name (ID) of the created bucket"
  value       = aws_s3_bucket.demo.id
}

output "bucket_arn" {
  description = "ARN of the created bucket"
  value       = aws_s3_bucket.demo.arn
}
