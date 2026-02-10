output "final_ecr_url" {
  value = module.ecr.repository_url
}

output "lambda_function_name" {
  value = module.lambda.function_name
}
