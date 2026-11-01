terraform {
  backend "s3" {
    bucket       = "enterprise-devsecops-tfstate-230944684832-ap-southeast-2"
    key          = "enterprise-devsecops/dev/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
