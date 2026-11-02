variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN used by the EKS control plane"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN used by EKS worker nodes"
  type        = string
}

variable "cluster_subnet_ids" {
  description = "Private subnet IDs for the EKS control plane"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Public subnet IDs for the EKS worker nodes"
  type        = list(string)
}

variable "cluster_public_access_cidrs" {
  description = "Public IPv4 CIDRs allowed to access the Kubernetes API"
  type        = list(string)

  validation {
    condition     = length(var.cluster_public_access_cidrs) > 0
    error_message = "At least one public access CIDR must be provided."
  }
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 1
}
