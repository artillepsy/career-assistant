# CI/CD Pipeline Setup Guide

This document explains the CI/CD pipeline configuration in `pipeline.yml` and provides step-by-step setup instructions.

## Overview

The pipeline consists of two main jobs:

1. **build-and-test**: Builds the Java application, runs tests, and performs code quality analysis with SonarCloud
2. **deploy-infrastructure**: Deploys AWS infrastructure using Terraform after successful build

The pipeline triggers automatically on every push to the `master` branch.

## What It Does

### Job 1: Build and Test

- Checks out the repository code
- Sets up JDK 25 (Zulu distribution)
- Builds the Maven project
- Runs unit tests
- Performs static code analysis with SonarCloud
- Waits for SonarCloud quality gate to pass

### Job 2: Deploy Infrastructure

- Only runs if build-and-test succeeds
- Authenticates with AWS using OIDC (OpenID Connect)
- Initializes Terraform
- Applies infrastructure changes to AWS

## Prerequisites

Before setting up the pipeline, you need:

1. **GitHub repository** with this codebase
2. **AWS account** with appropriate permissions
3. **SonarCloud account** (free for public repositories)
4. **Maven project** configured in the repository root

## Setup Instructions

For detailed Terraform configuration and infrastructure setup, see [README.md](../../terraform/README.md).

