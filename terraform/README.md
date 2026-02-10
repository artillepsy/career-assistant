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

### [**AWS ECR Module (Elastic Container Registry)**](./modules/ecr/README.md)

Amazon ECR is a fully managed Docker container registry that makes it easy to store, manage, and deploy Docker container
images.

**Purpose in this project:**

- Stores Docker images for Lambda functions
- Provides secure, scalable container image storage
- Integrates seamlessly with AWS Lambda for container-based deployments

### [**AWS Lambda**](./modules/lambda/README.md)

AWS Lambda is a serverless compute service that runs code in response to events without requiring server management.

**Purpose in this project:**

- Executes application's backend code in a serverless environment
- Scales automatically based on demand
- Reduces operational overhead and costs
- Pulls container images from ECR for deployment

## Deployment Workflow

1. **Build**: Docker images are built for Lambda functions via GitHub Actions
2. **Push**: Images are pushed to ECR repositories
3. **Deploy**: Terraform provisions Lambda functions using images from ECR
4. **Update**: Infrastructure changes are applied through Terraform workflows

## TODO:

- Add API Gateway for Lambda functions
- Add CloudWatch Logs for Lambda functions
- Add RDS for database
