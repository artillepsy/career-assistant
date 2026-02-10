output "role_arn" {
  description = "The ARN of the IAM role for GitHub Actions. Add this to GitHub Secrets as AWS_ROLE_ARN."
  value       = aws_iam_role.github_actions.arn
}