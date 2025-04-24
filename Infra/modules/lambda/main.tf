resource "aws_lambda_function" "image_processor" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "./lambda_function/lambda_function.zip"
  source_code_hash = filebase64sha256("./lambda_function/lambda_function.zip")

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      DEST_BUCKET = var.destination_bucket
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.source_bucket_arn
}

resource "aws_s3_bucket_notification" "source_bucket_notification" {
  bucket = var.source_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

