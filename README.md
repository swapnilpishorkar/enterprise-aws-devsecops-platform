# Enterprise AWS DevSecOps Platform

## Project Overview

An AWS-based DevSecOps portfolio project demonstrating automated infrastructure provisioning, containerized application delivery, and Kubernetes deployment using Terraform, Jenkins, Docker, Amazon ECR, and Amazon EKS.

The platform implements a CI/CD workflow that automatically tests application code, builds a versioned Docker image, publishes it to Amazon ECR, and deploys it to an Amazon EKS cluster.

The infrastructure is managed using reusable Terraform modules, with remote state stored in Amazon S3.

> **Project status:** Working end-to-end CI/CD deployment verified in an AWS development environment. This is a portfolio/lab implementation, not an independently audited production platform.

## Objectives

- Provision AWS infrastructure using modular Terraform.
- Manage Terraform state remotely using Amazon S3 and native S3 state locking.
- Build and test a Python Flask application.
- Package the application using Docker and run it as a non-root user.
- Automate CI/CD using Jenkins Declarative Pipeline.
- Publish versioned container images to Amazon ECR.
- Deploy application updates to Amazon EKS.
- Understand Kubernetes Deployments, Pods, Services, namespaces, and health probes.
- Apply IAM-based authentication and network restrictions.
- Document troubleshooting, verification, and operational procedures.

## Technology Stack

| Category | Technology |
|---|---|
| Operating System | Amazon Linux 2023 |
| Cloud Platform | AWS |
| Version Control | Git and GitHub |
| Application | Python, Flask, Gunicorn |
| Testing | pytest |
| Containerization | Docker |
| CI/CD | Jenkins |
| Infrastructure as Code | Terraform |
| Remote State | Amazon S3 with native state locking |
| Container Registry | Amazon ECR |
| Container Orchestration | Kubernetes, Amazon EKS |
| AWS Networking | VPC, public/private subnets, route tables, security groups |
| Identity and Access | AWS IAM and EC2 instance profile |
| Kubernetes CLI | kubectl |
| Package Management | Helm |

## Architecture

### CI/CD Workflow

1. Developer pushes code to GitHub.
2. Jenkins checks out the latest source code.
3. Jenkins installs application and test dependencies.
4. pytest executes automated application tests.
5. Jenkins builds a Docker image.
6. Jenkins authenticates to Amazon ECR using temporary AWS credentials.
7. Jenkins pushes a uniquely tagged image to ECR.
8. Jenkins authenticates to Amazon EKS using the EC2 instance profile and AWS CLI.
9. Jenkins updates the Kubernetes Deployment with the new image.
10. Kubernetes performs a rolling update.
11. Jenkins waits for rollout completion and checks the running Pods.

### AWS Infrastructure

- VPC with CIDR `10.0.0.0/16`.
- Two public and two private subnets across two Availability Zones.
- Internet Gateway and public/private route tables.
- Application and ALB security groups.
- IAM roles for the EKS cluster and worker nodes.
- Amazon ECR repository with immutable image tags.
- Amazon EKS managed Kubernetes cluster and managed node group.
- Amazon S3 remote Terraform state bucket with encryption, versioning, and public access blocked.

No NAT Gateway is configured in the current development environment.

### Kubernetes Deployment

The application is deployed in the `devsecops` namespace.

Kubernetes resources include:

- Namespace: `devsecops`
- Deployment: `enterprise-devsecops-app`
- Service: `enterprise-devsecops-service`
- Container port: `5000`
- Service port: `80`
- Readiness and liveness probes using `/health`
- CPU and memory requests and limits
- One application replica in the current development configuration

The application Service uses `ClusterIP`. Local testing is performed using Kubernetes port-forwarding.

## Repository Structure

```text
enterprise-devsecops-platform/
├── app/
│   └── app.py
├── tests/
├── kubernetes/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── terraform/
│   ├── environments/
│   │   └── dev/
│   └── modules/
│       ├── vpc/
│       ├── security-groups/
│       ├── iam/
│       ├── ecr/
│       └── eks/
├── Dockerfile
├── Jenkinsfile
├── requirements.txt
├── requirements-dev.txt
├── .gitignore
└── README.md
```

## Application Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Application information |
| `/health` | Application health check |

Example health check:

```bash
curl http://127.0.0.1:8082/health
```

Expected response:

```json
{"status":"UP"}
```

## CI/CD Image Versioning

The Jenkins pipeline creates image tags using the Jenkins build number and Git commit SHA.

Example:

```text
ci-5-d35d740
```

This provides traceability between a deployed container image, its Jenkins build, and the corresponding Git commit.

## Verification

The following have been successfully verified:

- Python application tests passed.
- Docker image built successfully.
- Jenkins authenticated to Amazon ECR.
- Docker image pushed to Amazon ECR.
- Jenkins authenticated to Amazon EKS.
- Kubernetes Deployment updated successfully.
- Kubernetes rolling update completed successfully.
- Application Pod reached `Running` and `Ready`.
- `/health` returned HTTP 200.
- `/` returned HTTP 200.

Latest verified deployment image:

```text
230944684832.dkr.ecr.ap-southeast-2.amazonaws.com/enterprise-devsecops-app:ci-5-d35d740
```

## Security Principles

- Use IAM roles and temporary credentials instead of permanent AWS access keys.
- Avoid committing secrets, credentials, private keys, Terraform state, and environment-specific variables.
- Use restrictive security group rules.
- Restrict the EKS public API endpoint to an approved client CIDR.
- Use non-root containers.
- Use immutable ECR image tags.
- Configure Kubernetes resource requests, limits, and health probes.
- Protect remote Terraform state using encryption, versioning, and public access blocking.

## Known Limitations and Future Improvements

The following capabilities are not yet implemented or verified:

- AWS Application Load Balancer and public Ingress.
- AWS Load Balancer Controller and IRSA/Pod Identity integration.
- CloudWatch monitoring, dashboards, and alerting.
- Multi-replica production high availability and autoscaling.
- Automated rollback and production approval gates.
- Comprehensive secrets-management integration.
- Full production security and resilience assessment.

ALB controller integration is currently blocked by an AWS Organizations Service Control Policy denying required IAM OIDC provider operations. This is an account-level permissions limitation, not a Kubernetes application failure.

Trivy scanning is not included in the current Jenkins pipeline.

## Cost and Deployment Safety

This project uses a development environment and is not intended to run continuously.

AWS resources such as EKS control planes, EC2 worker nodes, EBS volumes, and other provisioned services may incur charges.

Review AWS billing regularly and destroy or stop resources when they are no longer required. Preserve the remote Terraform state backend until infrastructure cleanup and state verification are complete.

## Disclaimer

This is a hands-on DevSecOps learning and portfolio project demonstrating practical AWS, Terraform, Docker, Jenkins, and Kubernetes workflows.

The implementation demonstrates working automation but should not be represented as independently audited or fully production-ready.
