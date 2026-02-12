# Terraform Infrastructure Configuration

## Table of Contents

- [Purpose](#purpose)
- [Provider](#provider)
- [Services](#services)
   - [AWS ECR Module (Elastic Container Registry)](#1-aws-ecr-module-elastic-container-registry--readme)
   - [AWS Lambda for API](#2-aws-lambda-for-api--readme)
   - [AWS RDS Module (Relational Database Service)](#3-aws-rds-module-relational-database-service--readme)
- [Bootstrap](#bootstrap--readme)
- [Cleaning Up](#cleaning-up)
- [Check Existing Resources](#check-existing-resources)
- [Deployment Workflow](#deployment-workflow)
- [TODO](#todo)

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

### 3. AWS RDS Module (Relational Database Service) | [README](./modules/rds/README.md)

Amazon RDS is a managed relational database service that simplifies database setup, operation, and scaling in the cloud.

**Purpose in this project:**

- Provides a PostgreSQL database for persistent data storage
- Manages automated backups, patches, and maintenance
- Integrates with Lambda functions through VPC networking
- Ensures data durability and high availability

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

3. Apply the bootstrap configuration with your GitHub details. You can manually enter your GitHub username and repo name,
   or you can run the following command to automatically extract them from your git remote. 
   
   ```bash
   $URL = (git config --get remote.origin.url); `
   $REPO_NAME = $URL.Split('/')[-1].Replace('.git',''); `
   $USER_NAME = $URL.Split('/')[-2]; `
   
   terraform apply -var="github_username=$USER_NAME" -var="github_repo_name=$REPO_NAME"
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

## Cleaning Up

⚠️ **Warning**: These operations are destructive and will permanently delete resources. Always ensure you have backups
of any important data before proceeding.

To remove all resources from AWS, run the following commands:

1. Setup Variables
   ```bash
   $URL = (git config --get remote.origin.url); `
   $REPO_NAME = $URL.Split('/')[-1].Replace('.git',''); `
   $USER_NAME = $URL.Split('/')[-2]; `
   $BUCKET = "${REPO_NAME}-tfstate-${USER_NAME}"; 
   ```
    
2. Cleanup Main App (S3 State)
   ```bash
   terraform -chdir=terraform init -reconfigure -backend-config="bucket=$BUCKET"; `
   terraform -chdir=terraform destroy -auto-approve -var="project_name=$REPO_NAME";
   ```
   
3. Cleanup Bootstrap (Local State)
   ```bash
   terraform -chdir=terraform/bootstrap init; `
   terraform -chdir=terraform/bootstrap destroy -auto-approve `
      -var="github_username=$USER_NAME" `
      -var="github_repo_name=$REPO_NAME";
   ```
4. Delete all hidden terraform metadata in every folder
   ```bash
   Get-ChildItem -Path . -Include .terraform, .terraform.lock.hcl, terraform.tfstate, terraform.tfstate.backup -Recurse -Force | Remove-Item -Recurse -Force
   ```
This will permanently delete all AWS resources created by this project.

## Check Existing Resources

1. Identify current Repository Name
   ```bash
   $REPO_NAME = (git config --get remote.origin.url).Split('/')[-1].Replace('.git',''); `
   Write-Host "Current Repository: $REPO_NAME" -ForegroundColor Green; 
   ```
   
2. Check for IAM Roles (which often miss tags)
   ```bash
   aws iam list-roles --query "Roles[?contains(RoleName, '$REPO_NAME')].RoleName" --output table;
   ```
   
3. List every ARN with that project tag
   ```bash
   aws resourcegroupstaggingapi get-resources `
     --tag-filters Key=Project,Values=$REPO_NAME `
     --query 'ResourceTagMappingList[].ResourceARN' `
     --output table
   ```

## Deployment Workflow

1. **Build**: Docker images are built for Lambda functions via GitHub Actions
2. **Push**: Images are pushed to ECR repositories
3. **Deploy**: Terraform provisions Lambda functions using images from ECR
4. **Update**: Infrastructure changes are applied through Terraform workflows



## TODO:

- Add API Gateway for Lambda functions. Now it's only accessible via simple Lambda URL
- Add CloudWatch Logs for Lambda functions
- Add RDS for database
- Add SnapStart for Lambda functions in the future (it doesn't support docker images yet) to reduce cold start time.
  (Alternative) Increase Lambda memory size instead.
