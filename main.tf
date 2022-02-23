terraform {
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc1" {
  cidr_block       = "${var.cidr}"
  instance_tenancy = "default"

  
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "${var.sub_cidr}"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.subnet_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id     = aws_vpc.vpc1.id

  tags = {
    Name = "${var.ig_name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.vpc1.id

  tags = {
    Name = "${var.route_name}"
  }
}

resource "aws_route_table_association" "sn" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "sg" {
  name        = "${var.sg_name}"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.sg_name}"
  }

}
data "aws_vpc" "vpc1" {
  cidr_block       = "${var.cidr}"
  depends_on       =  [aws_vpc.vpc1, aws_subnet.subnet1]

}

data "aws_subnet" "subnet1" {
  vpc_id     = "${data.aws_vpc.vpc1.id}"
  cidr_block = "${var.sub_cidr}"
   
}

resource "aws_instance" "ec2" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "${var.instance_type}"
  key_name      = "ohio"
  subnet_id     =  "${data.aws_subnet.subnet1.id}"
  vpc_security_group_ids = [aws_security_group.sg.id]
  depends_on    =  [aws_vpc.vpc1, aws_subnet.subnet1]

    tags = {
      Name = "${var.instance_name}"
  }
}
