variable "function_name" {
  type = string
}

variable "image_uri" {
  description = "The ECR image URI (passed from the ECR module)"
  type        = string
}

variable "memory_size" {
  default = 1024 # Recommended minimum for Java SnapStart performance
  type = number
}