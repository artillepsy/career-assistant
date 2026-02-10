# --------------- GitHub Actions IAM Role Configuration ---------------

# Fetch GitHub's security certificate dynamically
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# Create the OIDC Trust Bridge
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

# Create the IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name = "career-assistant-deployer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub": "repo:${var.github_username}/${var.github_repo_name}:*"
        }
        StringEquals = {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }]
  })
}

# Attach AdministratorAccess so GitHub can deploy the rest of the infra
resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



# --------------- State Bucket Configuration  ---------------

# The State Bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "${var.github_repo_name}-tfstate-${var.github_username}" # Must be unique globally
  force_destroy = true
}

# Enable Versioning (Required for native locking and safety)
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration { status = "Enabled" }
}

# S3 Public Access Block (Security Best Practice)
resource "aws_s3_bucket_public_access_block" "state_lock" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add S3 permissions to the existing GitHub IAM Role
resource "aws_iam_role_policy" "state_access" {
  name = "terraform-state-access"
  role = aws_iam_role.github_actions.id # Links to the existing role

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.terraform_state.arn]
      },
      {
        # .tflock is required for Terraform 1.10+ native locking
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.terraform_state.arn}/*"]
      }
    ]
  })
}