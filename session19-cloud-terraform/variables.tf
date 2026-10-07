variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR allowed to reach the app on HTTP port 8000 (e.g. \"203.0.113.10/32\")"
  type        = string
}
