terraform {
    required_version = ">= 1.5.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
    
    # add tag: easy to audit and trace
    default_tags {
        tags = {
            Project     = "security-lab"
            ManagedBy   = "terraform"
            Environment = "dev"
        }
    }
}