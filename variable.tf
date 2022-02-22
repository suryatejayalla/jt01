variable "cidr"{
    type = string
}
variable "vpc_name"{
    type = string
}
variable "sub_cidr"{
    type = string
}
variable "subnet_name"{
    type = string
}
variable "az"{
    type = string
}
variable "ig_name"{
    type = string
}
variable "route_name"{
    type = string
}
variable "instance_type"{
    type = string
}
variable "instance_name"{
    type = string
}
variable "region"{
    type = string
}
variable "sg_name"{
    type = string
}
variable "aws_access_key" {
  type = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}
