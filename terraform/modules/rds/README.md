# RDS Module

## Overview

This Terraform module provisions and manages an AWS RDS PostgreSQL database instance. It creates a fully configured
PostgreSQL database with customizable credentials and networking settings.

## Features

- Creates an AWS RDS PostgreSQL instance with configurable database name, username, and password
- Supports VPC security group integration for controlled network access
- Provides database endpoint output for application connection strings
- Configured for production-ready settings including encryption and automated backups
- Enables secure communication between Lambda functions and the database through shared security groups
