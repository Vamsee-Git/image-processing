variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "source_bucket_name" {
  description = "The name of the source S3 bucket"
  type        = string
}

variable "destination_bucket_name" {
  description = "The name of the destination S3 bucket"
  type        = string
}

variable "lambda_role_name" {
  description = "The name of the IAM role for Lambda"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}
