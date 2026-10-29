# Enterprise AWS DevSecOps Platform

## Project Overview

Build an automated DevSecOps platform that demonstrates secure infrastructure
provisioning, containerized application delivery, continuous integration and
continuous deployment using AWS, Terraform, Docker, Jenkins, Linux, Git, and GitHub.

The project will be developed incrementally, with validation and security checks
before deployment.

## Objectives

- Manage infrastructure as code using Terraform.
- Build and test a Python application.
- Package the application using Docker.
- Automate CI/CD using Jenkins and GitHub.
- Scan source files and container images using Trivy.
- Learn Kubernetes fundamentals and deployment workflows.
- Design AWS infrastructure using security and reliability best practices.
- Monitor application health and deployment results.
- Avoid committing credentials, secrets, Terraform state, or other sensitive files.

## Technology Stack

- Operating System: Amazon Linux 2023
- Version Control: Git and GitHub
- Application: Python and Flask
- Containerization: Docker
- CI/CD: Jenkins
- Infrastructure as Code: Terraform
- Security Scanning: Trivy
- Cloud Platform: Amazon Web Services (AWS)
- Container Registry: Amazon ECR
- Orchestration: Kubernetes, with EKS as a planned AWS target
- Monitoring: Amazon CloudWatch

## Planned Architecture

1. Developers push application and infrastructure changes to GitHub.
2. Jenkins checks out the repository and runs validation and tests.
3. Trivy scans source files and the built container image.
4. Docker builds a versioned application image.
5. Approved images can be published to Amazon ECR.
6. Kubernetes deployment and application health checks are performed
   when the target environment is available and approved.
7. Terraform manages the AWS infrastructure and its configuration.

## Planned Repository Structure

- app/ — Python application
- tests/ — Automated tests
- docker/ — Container-related files
- jenkins/ — Jenkins pipeline definitions
- terraform/ — Reusable infrastructure modules and environments
- kubernetes/ — Kubernetes manifests and overlays
- security/ — Security policies and scan configuration
- scripts/ — Automation and helper scripts
- docs/ — Architecture, setup, operations, and troubleshooting documentation

## Security Principles

- Never commit passwords, access keys, private keys, or environment secrets.
- Prefer IAM roles and temporary credentials over long-lived access keys.
- Apply least-privilege access and restrictive network rules.
- Scan source code and container images before publishing.
- Protect Terraform state and use a remote backend when configured.
- Require explicit approval before production deployment.

## Cost and Deployment Safety

Local development and validation will be preferred wherever practical.
AWS resources will only be created after checking account eligibility, estimated
costs, available credits, and the required permissions.

A working portfolio implementation does not automatically mean the platform
has been independently audited or is suitable for a real production workload.

## Project Status

Initial repository structure created. Application, automated pipeline,
security scanning, Terraform modules, and Kubernetes deployment are planned
implementation stages and will be marked complete only after verification.
