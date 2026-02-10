# Lambda Module

## Overview

This Terraform module provisions and manages an AWS Lambda function optimized for Java 25. It
deploys Lambda functions using container images stored in Amazon ECR repositories. The module is built for integration
within broader infrastructure configurations and works in conjunction with the ECR module to facilitate containerized
application deployment.

## Features

- Creates an AWS Lambda function with a configurable name
- Supports container image deployment from ECR repositories
- Accepts image URI as input for flexible image management
- Outputs the Lambda function name for reference by other modules