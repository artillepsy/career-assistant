variable "repo_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "force_delete" {
  description = "Whether to delete the repository even if it contains images"
  type        = bool
  default     = true
}
