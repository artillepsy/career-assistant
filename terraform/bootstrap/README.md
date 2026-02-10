# Bootstrap Module

## Overview

This Terraform module sets up the foundational infrastructure required for GitHub Actions to deploy AWS resources
securely using OpenID Connect (OIDC) authentication. It creates an IAM role with a trust relationship that allows
GitHub Actions workflows to assume AWS credentials without storing long-lived access keys. This bootstrap module must
be applied first before deploying the rest of the infrastructure.

## Features

- Creates an OIDC identity provider for GitHub Actions integration with AWS
- Dynamically fetches GitHub's security certificate for trust validation
- Creates an IAM role with web identity federation for GitHub Actions
- Configures trust policy to restrict access to specific GitHub repository
- Attaches AdministratorAccess policy to enable full infrastructure deployment
- Eliminates the need for storing AWS credentials in GitHub Secrets
