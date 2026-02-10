# Terraform Infrastructure Configuration

## Purpose

This Terraform configuration manages cloud infrastructure as code (IaC), enabling automated provisioning, deployment,
and management of AWS resources. By using Terraform, we maintain:

- **Version Control**: Infrastructure changes are tracked in source control
- **Reproducibility**: Consistent deployments across environments
- **Automation**: Reduced manual configuration and human error
- **Documentation**: Infrastructure is self-documented through code

## Provider

This project uses **AWS (Amazon Web Services)** as the cloud provider. Terraform communicates with AWS APIs to create,
modify, and destroy resources according to the configuration files.

## Services

### 1. AWS ECR Module (Elastic Container Registry) | [README](./modules/ecr/README.md)

Amazon ECR is a fully managed Docker container registry that makes it easy to store, manage, and deploy Docker container
images.

**Purpose in this project:**

- Stores Docker images for Lambda functions
- Provides secure, scalable container image storage
- Integrates seamlessly with AWS Lambda for container-based deployments

### 2. AWS Lambda for API | [README](./modules/lambda/README.md)

AWS Lambda is a serverless compute service that runs code in response to events without requiring server management.

**Purpose in this project:**

- Executes application's backend code in a serverless environment
- Scales automatically based on demand
- Reduces operational overhead and costs
- Pulls container images from ECR for deployment

## Bootstrap | [README](./bootstrap/README.md)

Before deploying the main infrastructure, you must set up the OIDC (OpenID Connect) trust relationship between GitHub
Actions and AWS. This allows GitHub Actions to authenticate with AWS without storing long-lived credentials.

⚠️ **Note**: This bootstrap step only needs to be run once per AWS account and repository.

**Steps:**

1. Navigate to the bootstrap directory:
   ```bash
   cd terraform/bootstrap
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the bootstrap configuration with your GitHub details:
   ```bash
   terraform apply -var="github_username=YOUR_GITHUB_USERNAME" -var="github_repo_name=YOUR_REPO_NAME"
   ```

4. After successful deployment, note the IAM Role ARN from the output.

5. Add the Role ARN to your GitHub repository secrets as `AWS_ROLE_ARN`:
    - Go to your repository → Settings → Secrets and variables → Actions
    - Create a new secret named `AWS_ROLE_ARN`
    - Paste the Role ARN value

**What this creates:**

- **OIDC Provider**: Establishes trust between GitHub Actions and AWS
- **IAM Role**: `career-assistant-deployer` role that GitHub Actions assumes
- **Permissions**: AdministratorAccess policy for deploying infrastructure

## Deployment Workflow

1. **Build**: Docker images are built for Lambda functions via GitHub Actions
2. **Push**: Images are pushed to ECR repositories
3. **Deploy**: Terraform provisions Lambda functions using images from ECR
4. **Update**: Infrastructure changes are applied through Terraform workflows



## TODO:

- Add API Gateway for Lambda functions. Now it's only accessible via simple Lambda URL
- Add CloudWatch Logs for Lambda functions
- Add RDS for database
- Push actual Docker Images built by GitHub Actions to ECR
- Add SnapStart for Lambda functions in the future (it doesn't support docker images yet) to reduce cold start time
