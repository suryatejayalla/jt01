provider "aws" {
version  = "~> 3.0"
region  = "${var.region}"
access_key = var.aws_access_key
secret_key = var.aws_secret_key
}
