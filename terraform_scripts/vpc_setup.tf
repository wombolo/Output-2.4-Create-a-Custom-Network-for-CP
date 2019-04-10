# vpc_setup.tf

resource "aws_vpc" "output2_4_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name= "Output 2.2- VPC"
  }
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = "${aws_vpc.output2_4_vpc.id}"

  tags = {
    Name = "main internet gateway"
  }
}

//Provision Elastic IP
resource "aws_eip" "nat-elastic-ip" {
  vpc = true
}


resource "aws_nat_gateway" "nat-gw1" {
  depends_on = ["aws_internet_gateway.igw1"]

  allocation_id = "${aws_eip.nat-elastic-ip.id}"
  subnet_id = "${aws_subnet.public.id}"

  tags = {
    Name = "NAT gateway"
  }
}


//------------- PUBLIC SUBNET ----------------------

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.output2_4_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_region}a"
  tags {
    Name = "Public Subnet"
  }
}

//Create public route_table
resource "aws_route_table" "public-RT" {
  vpc_id = "${aws_vpc.output2_4_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw1.id}"
  }
}


//Associate public route_table with public subnet
resource "aws_route_table_association" "public" {
  subnet_id= "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public-RT.id}"
}




//------------- PRIVATE SUBNET ----------------------

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.output2_4_vpc.id}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${var.aws_region}b"

  tags {
    Name = "Private Subnet"
  }
}

//Create private route_table
resource "aws_route_table" "private-RT" {
  vpc_id = "${aws_vpc.output2_4_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gw1.id}"
  }
}



//Associate public route_table with public subnet
resource "aws_route_table_association" "nat" {
  subnet_id  = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private-RT.id}"
}

