output "repository_url" {
  description = "The URL of the repository"
  value = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "Amazon Resource Name (ARN) of the repository"
  value = aws_ecr_repository.this.arn
}
