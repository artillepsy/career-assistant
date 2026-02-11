variable "aws_region" {
  type = string
  default = "eu-central-1"
}

variable "project_name" {
  type = string
}

variable "api_image_uri" {
  description = "The ECR image URI for the Lambda function (API)"
  type        = string
}

variable "db_name" {
  type = string
  default = "app_db"
}

variable "db_username" {
  type = string
  default = "app_admin"
}

# Stored in GitHub secrets, provided in pipeline by default
variable "db_password" {
  type = string
  sensitive = true
}
