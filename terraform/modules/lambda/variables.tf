variable "function_name" {
  type = string
}

variable "api_image_uri" {
  description = "The ECR image URI (passed from the ECR module)"
  type        = string
}

variable "memory_size" {
  default = 1024 # Recommended minimum for Java SnapStart performance
  type = number
}

variable "db_url" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "vpc_subnet_ids" {
  type        = list(string)
}
variable "vpc_security_group_ids" {
  type        = list(string)
}

