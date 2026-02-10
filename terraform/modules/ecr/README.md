# ECR Module

## Overview

This Terraform module creates and manages an Amazon Elastic Container Registry (ECR) repository for storing Docker
container images. The module is designed to be used as part of a larger infrastructure setup, particularly for Lambda
functions that use container images.

## Features

- Creates an AWS ECR repository with a configurable name
- Supports force deletion of repositories (including those containing images)
- Outputs the repository URL for use by other modules
- Limits the image count to 10 to save money on storage costs