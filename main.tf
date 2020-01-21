terraform {
  required_version = ">= 0.11.0"
}

variable "role_name" {}
variable "eks_cluster_name" {}
variable "iam_policy" {}
variable "service_account_name" {}
variable "service_account_namespace" {}

data "aws_eks_cluster" "cluster" {
  name = "${var.eks_cluster_name}"
}

data "aws_caller_identity" "current" {}
