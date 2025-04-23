variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for Lambda"
  type        = string
}

variable "source_bucket" {
  description = "The name of the source S3 bucket"
  type        = string
}

variable "destination_bucket" {
  description = "The name of the destination S3 bucket"
  type        = string
}

variable "source_bucket_arn" {
  description = "The arn of the source S3 bucket"
  type        = string
}

variable "source_bucket_id" {
  description = "The id of the source S3 bucket"
  type        = string
}

