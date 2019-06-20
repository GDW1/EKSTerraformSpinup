variable "arn" {
  default = "arn:aws:iam::921409356621:role/EKS-cluster"
}

variable "region" {
  default = "us-west-2"
}

variable "availability_zones" {
    type = "map"
    default = {
        "1" = "us-west-2c"
        "2" = "us-west-2d"
        "3" = "us-west-2e"
    }
}

variable "cidr_blocks" {
    type = "map"
    default = {
        "1" = "172.10.0.0/16"
        "2" = "172.15.0.0/16"
    }
}

variable "instance_ami" {
    default = "ami-089d3b6350c1769a6"
}

variable "instance_type" {
    default = "t2.nano"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}

