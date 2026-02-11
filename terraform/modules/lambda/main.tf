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
    allow_origins     = ["*"]
    allow_methods     = ["GET", "POST"]
    allow_headers     = ["*"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# Permission 1: Allow the URL specifically
resource "aws_lambda_permission" "url_permission" {
  statement_id           = "AllowFunctionURL"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.this.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
  qualifier              = aws_lambda_alias.live.name
}

# Permission 2: Allow general invocation for the public principal
resource "aws_lambda_permission" "public_invoke" {
  statement_id  = "AllowPublicInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "*"
  qualifier     = aws_lambda_alias.live.name
}