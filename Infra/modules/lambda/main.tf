resource "aws_lambda_function" "image_processor" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "lambda_function/package/lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function/package/lambda_function.zip")

  environment {
    variables = {
      DEST_BUCKET = var.destination_bucket
    }
  }
}

resource "aws_s3_bucket_notification" "source_bucket_notification" {
  bucket = var.source_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
