resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role = aws_iam_role.lambda_exec.arn
  package_type = "Image"
  image_uri = var.image_uri

  architectures = ["arm64"] # Java 25 on Graviton is 34% better price-performance
  memory_size = var.memory_size
  timeout = 30

  # SnapStart configuration
  publish = true # Tells AWS to create a new Version on every change
  snap_start {
    apply_on = "PublishedVersion"
  }
}

# An Alias acts as a "pointer" to the SnapStart-enabled version
resource "aws_lambda_alias" "live" {
  name = "live"
  function_name = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
}