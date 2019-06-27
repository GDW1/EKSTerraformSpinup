provider "aws" {
    region  = "${var.region}"
    profile = "default"
}

resource "aws_vpc" "eks_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name = "eks_vpc"
    }
}

resource "aws_subnet" "subnet" {
    count      = 3
    vpc_id     = "${aws_vpc.eks_vpc.id}"
    cidr_block = "10.0.${count.index}.0/24"
    availability_zone = "${var.availability_zones[count.index]}"
    tags = {
        name = "eks_subnet"
    }
}

module "eks" {
    source       = "terraform-aws-modules/eks/aws"
    version      = "5.0.0"
    cluster_name = "${var.cluster-name}"
    subnets      = ["${aws_subnet.subnet.0.id}", "${aws_subnet.subnet.1.id}", "${aws_subnet.subnet.2.id}"]
    vpc_id       = "${aws_vpc.eks_vpc.id}"
    worker_groups = [
        {
        instance_type = "t2.nano"
        asg_max_size  = 5
        tags = {
            key                 = "foo"
            value               = "bar"
            propagate_at_launch = true
        }
        }
    ]
}