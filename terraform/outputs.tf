output "final_ecr_url" {
  value = module.ecr.repository_url
}

output "lambda_function_name" {
  value = module.api_lambda.function_name
}

output "lambda_public_url" {
  value = module.api_lambda.function_url
}
