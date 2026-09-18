variable "aws_region" {
    description = "AWS deployment region"
    type        = string
    default     = "us-east-2"
}

variable "vpc_cidr" {
    description = "VPC CIDR Block"
    type        = string
    default     = "10.0.0.0/16"
}