terraform {
  required_version = ">= 1.0.0" # Ensure that the Terraform version is 1.0.0 or higher

  backend "s3" {
    # catch bucket name from CI/CD
    key          = "terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true

    # Enable S3 Native Locking (Available in Terraform 1.10+)
    # This removes the need for a DynamoDB table!
    use_lockfile = true
  }
}

# Call the ECR module
module "ecr" {
  source = "./modules/ecr"
  repo_name = "${var.project_name}-repo"
}

# Call the Lambda module
module "api_lambda" {
  source = "./modules/lambda"
  function_name = "${var.project_name}-api"

  # Passing the OUTPUT of the ECR module as the INPUT to the Lambda module
  image_uri = "${module.ecr.repository_url}:latest"
}
