resource "aws_vpc" "target_vpc" {
    cidr_block = "${var.cidr_block}"
    instance_tenancy = "default"
    tags = {
        Name = "${var.vpc_name}"
    }
}

resource "aws_subnet" "public_subnet_main" {
    vpc_id = "${aws_vpc.target_vpc.id}"
    cidr_block = "${var.secondary_cidr_block_public}"
    availability_zone = "${var.set_availability_zone}"
    tags = {
        Name = "${var.vpc_name}-public-subnet"
    }    
}

resource "aws_subnet" "private_subnet_main" {
    vpc_id = "${aws_vpc.target_vpc.id}"
    cidr_block = "${var.secondary_cidr_block_private}"
    availability_zone = "${var.set_availability_zone}"
    tags = {
        Name = "${var.vpc_name}-private-subnet"
    }     
}

resource "aws_internet_gateway" "target_vpc_internet_gateway" {
    vpc_id = "${aws_vpc.target_vpc.id}"
    tags = {
        Name = "${var.vpc_name}-internet-gateway"
    }
}