provider "aws" {
    access_key = "${var.my_access_key}"
    secret_key = "${var.my_secret_key}"
    region = "${var.aws_region}"
}

# Define our VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-main"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = "true"
	
  tags = {
    Name = "Public-Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr_b}"
  map_public_ip_on_launch = "false"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "Private-Subnet-B"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "VPC IGW"
  }
}

resource "aws_eip" "terraformtraining-nat" {
  vpc = true
}
# Define the NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.terraformtraining-nat.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"
  depends_on = ["aws_internet_gateway.gw"]
  tags = {
    Name = "gw NAT"
  }
}

# Define the route table public
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Public Subnet RT"
  }
}

# Define the route table private
resource "aws_route_table" "private-rt" {
    vpc_id = "${aws_vpc.terraformtraining.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat.id}"
    }

    tags = {
        Name = "private-rt"
    }
}


# Assign the route table to the public Subnet
resource "aws_route_table_association" "public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

# Assign the route table to the private Subnet
resource "aws_route_table_association" "private-rt-1-a" {
    subnet_id = "${aws_subnet.private-subnet.id}"
    route_table_id = "${aws_route_table.private-rt.id}"
}
resource "aws_route_table_association" "tprivate-rt-2-b" {
    subnet_id = "${aws_subnet.private-subnet-b.id}"
    route_table_id = "${aws_route_table.private-rt.id}"
}

# Define the security group for private subnet
resource "aws_security_group" "sg_dev"{
  name = "sg_dev"
  description = "Allow traffic from public subnet and private"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.public_subnet_cidr}", "${var.private_subnet_cidr}", "${var.private_subnet_cidr_b}"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "sg_dev"
  }
}
