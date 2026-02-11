# CI/CD Pipeline Workflows

## Table of Contents

- [Pipeline Stages](#pipeline-stages)
   - [1. Build and Test (`build-and-test`)](#1-build-and-test-build-and-test)
   - [2. Create ECR (`deploy-ecr`)](#2-create-ecr-deploy-ecr)
   - [3. Build and Push Docker Images (`push-images-to-ecr`)](#3-build-and-push-docker-images-push-images-to-ecr)
   - [4. Deploy Infrastructure (`deploy-infrastructure`)](#4-deploy-infrastructure-deploy-infrastructure)
- [Workflow Execution Flow](#workflow-execution-flow)
   - [Terraform State Lock](#terraform-state-lock)

This document describes the CI/CD pipeline stages defined in `pipeline.yml` and their purposes.

## Pipeline Stages

The pipeline consists of four sequential stages that deploy the application infrastructure to AWS:

### 1. Build and Test (`build-and-test`)

**Purpose:** Validates code quality and runs tests before deployment.

**Actions:**

- Checks out the code from the repository
- Sets up JDK 25 with Maven caching
- Builds the application using Maven
- Runs unit tests and integration tests
- Performs static code analysis with SonarCloud
- Enforces quality gate requirements (build fails if quality gate fails)

**Triggers:** Runs on every push to the `master` branch

---

### 2. Create ECR (`deploy-ecr`)

**Purpose:** Provisions the AWS Elastic Container Registry (ECR) repository to store Docker images.

**Actions:**

- Authenticates with AWS using OIDC (OpenID Connect) via GitHub Actions
- Initializes Terraform with the remote state backend (S3 bucket)
- Runs `terraform apply` targeting only the ECR module
- Creates the ECR repository before Docker images are pushed

**Dependencies:** Requires `build-and-test` to complete successfully

**Why Separate:** The ECR repository must exist before Docker images can be pushed to it in the next stage.

---

### 3. Build and Push Docker Images (`push-images-to-ecr`)

**Purpose:** Builds multi-architecture Docker images and pushes them to ECR.

**Actions:**

- Authenticates with AWS and logs into Amazon ECR
- Sets up QEMU and Docker Buildx for multi-platform builds
- Builds Docker image for the API (`backend/career-assistant-api`) targeting ARM64 architecture
- Tags the image with the Git commit SHA for traceability
- Pushes the image to the ECR repository created in the previous stage
- Outputs the full image URI for use in the infrastructure deployment stage

**Dependencies:** Requires `deploy-ecr` to complete successfully

**Output:** `api_image_uri` - The full ECR image URI (used in the next stage)

---

### 4. Deploy Infrastructure (`deploy-infrastructure`)

**Purpose:** Provisions and updates all AWS infrastructure resources using Terraform.

**Actions:**

- Authenticates with AWS using OIDC
- Initializes Terraform with the remote state backend
- Runs `terraform apply` to create/update all infrastructure:
   - VPC and networking components
   - ECS cluster and services
   - Application Load Balancer
   - Security groups and IAM roles
   - CloudWatch logs
   - Any other resources defined in the Terraform configuration
- Passes the Docker image URI from the previous stage to deploy the latest version

**Dependencies:** Requires `push-images-to-ecr` to complete successfully

**Production Environment:** Requires manual approval if environment protection rules are configured

---

## Workflow Execution Flow

### Terraform State Lock

If you experience a Terraform state lock blocking deployment, follow these steps in Terminal:

1. Use this command to list your buckets and filter for "tfstate":
```bash
aws s3 ls | Select-String "tfstate"
```

2. List the files to find the lock. Look for the file ending in .tflock
```bash
# Replace <BUCKET_NAME> with your actual bucket name found in the output.
aws s3 ls s3://<BUCKET_NAME> --recursive
```

3. Delete the lock via CLI
    1. YOUR_BUCKET_NAME: This is the name of the S3 bucket where you store your Terraform state.
    2. YOUR_PROJECT_PATH: This is the folder path inside that bucket.
```bash
# Replace <BUCKET_NAME> and <PATH> with your actual details
aws s3 rm s3://<YOUR_BUCKET_NAME>/<YOUR_PROJECT_PATH>/terraform.tfstate.tflock
```

If you still experience issues with the same lock id, delete the lock manually in the AWS Console.

1. Go to your S3 bucket in the AWS Console.

2. Click the "Show versions" toggle switch (usually at the top right of the file list).

3. Find terraform.tfstate.tflock. You will now see multiple entries for it.

4. Select all of them and click Delete.

5. Confirm by typing permanently delete.