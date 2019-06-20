/*provider "aws" {
        region  = "${var.region.default}"
        profile = "default"
}
resource "aws_vpc" "exampleVPC" {
    cidr_block =  "var.cidr_blocks[\"1\"]"
    tags = {
        Name="exampleVPC_Guy"
    }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = "${aws_vpc.exampleVPC.id}"
  cidr_block = "${var.cidr_blocks["2"]}"
  tags = {
          name = "second_cidr_assositation_Guy"
  }
}

resource "aws_subnet" "default_az1" {
  vpc_id = "${aws_vpc.exampleVPC.id}"
  cidr_block = "${aws_vpc.exampleVPC.cidr_block}"
  availability_zone = "${var.availability_zones["1"]}"
}

resource "aws_subnet" "default_az2" {
  vpc_id = "${aws_vpc.exampleVPC.id}"
  cidr_block = "${aws_vpc_ipv4_cidr_block_association.secondary_cidr.cidr_block}"
  availability_zone = "${var.availability_zones["2"]}"
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  security_group_id = "${resource.aws_vpc.exampleVPC.default_security_group_id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_guestbook" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "TCP"
  security_group_id = "${resource.aws_vpc.exampleVPC.default_security_group_id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
  
resource "aws_eks_cluster" "testCluster" {
        name     = "testCluster"

        role_arn = "${var.arn}"

        vpc_config {
                subnet_ids = ["${aws_subnet.default_az1.id}", "${aws_subnet.default_az2.id}"]
        }
}

resource "aws_cloudformation_stack" "name" {
  
}

resource "aws_network_interface" "interfaceSub1" {
	subnet_id = "${aws_subnet.default_az1.id}"
	security_groups = ["${aws_security_group.subnet1.id}"]
}

resource "aws_network_interface" "interfaceSub2" { 
        subnet_id = "${aws_subnet.default_az2.id}"
        security_groups = ["${aws_security_group.subnet1.id}"]
}

resource "aws_instance" "instance1" {
	//host_id = "${aws_subnet.default_az1.host_id}"
	ami = "ami-089d3b6350c1769a6"
	instance_type = "t2.nano"
	network_interface {
		network_interface_id = "${aws_network_interface.interfaceSub1.id}"
		device_index         = 0
	}
}

resource "aws_instance" "instance2" {
        //host_id = "${aws_subnet.default_az2.host_id}"
        ami = "ami-089d3b6350c1769a6"
        instance_type = "t2.nano"
        network_interface {
                network_interface_id = "${aws_network_interface.interfaceSub2.id}"
                device_index         = 0
        }
}

output "endpoint" {
        value = "${aws_eks_cluster.testCluster.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
        value = "${aws_eks_cluster.testCluster.certificate_authority.0.data}"
}


*/