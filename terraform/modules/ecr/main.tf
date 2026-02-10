resource "aws_ecr_repository" "this" {
  name = var.repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = var.force_delete

  image_scanning_configuration {
    # Automatically scans Docker image for vulnerabilities on every push
    scan_on_push = true
  }

  encryption_configuration {
    # Standard AWS-managed encryption
    encryption_type = "AES256"
  }
}

# The policy deletes untagged images (old builds) automatically
resource "aws_ecr_lifecycle_policy" "cleanup" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the last 10 images"
      selection = {
        tagStatus = "any"
        countType = "imageCountMoreThan"
        countNumber = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}
