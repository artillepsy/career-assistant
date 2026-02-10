output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "lambda_alias_arn" {
  value = aws_lambda_alias.live.arn
}

output "function_url" {
  description = "The public HTTP URL for the Lambda function"
  value       = aws_lambda_function_url.api_url.function_url
}