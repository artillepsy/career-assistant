resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role = aws_iam_role.lambda_exec.arn
  package_type = "Image"
  image_uri = var.api_image_uri

  architectures = ["arm64"] # Java 25 on Graviton is 34% better price-performance
  memory_size = var.memory_size
  timeout = 30
}

# An Alias acts as a "pointer" to the SnapStart-enabled version
resource "aws_lambda_alias" "live" {
  name = "live"
  function_name = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
}

resource "aws_lambda_function_url" "api_url" {
  function_name = aws_lambda_function.this.function_name

  # Use "live" alias to ensure SnapStart is active on this URL
  qualifier = aws_lambda_alias.live.name
  authorization_type = "NONE" # Makes the URL public

  # todo: configure origins later, when the extension is ready to test
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST"]
    allow_headers     = ["*"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}