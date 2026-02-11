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
