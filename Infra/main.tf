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
  source              = "./modules/iam"
  role_name           = var.lambda_role_name
  source_bucket_name  = var.source_bucket_name
  destination_bucket_name = var.destination_bucket_name
}

module "lambda_function" {
  source            = "./modules/lambda"
  function_name     = var.lambda_function_name
  role_arn          = module.lambda_role.role_arn
  source_bucket     = module.source_bucket.bucket_name
  destination_bucket = module.destination_bucket.bucket_name
  depends_on        = [module.source_bucket, module.destination_bucket]
  source_bucket_arn = module.source_bucket.arn
}

module "cloudwatch" {
  source        = "./modules/cloudwatch"
  function_name = module.lambda_function.function_name
}
