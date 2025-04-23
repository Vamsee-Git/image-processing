provider "aws" {
  region = var.region
}

module "source_bucket" {
  source      = "./modules/s3"
  bucket_name = var.source_bucket_name
}

module "destination_bucket" {
  source      = "./modules/s3"
  bucket_name = var.destination_bucket_name
}

module "lambda_role" {
  source    = "./modules/iam"
  role_name = var.lambda_role_name
  source_bucket_name  = var.source_bucket_name
  destination_bucket_name = var.destination_bucket_name
}

module "lambda_function" {
  source            = "./modules/lambda"
  function_name     = var.lambda_function_name
  role_arn          = module.lambda_role.role_arn
  source_bucket     = var.source_bucket_name
  destination_bucket =  var.destination_bucket_name
}

module "cloudwatch" {
  source        = "./modules/cloudwatch"
  function_name = module.lambda_function.function_name
}
