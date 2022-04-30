output "created_vpc_id" {
    value = "${aws_vpc.target_vpc.id}"
}

output "created_internet_gateway_id" {
    value = "${aws_internet_gateway.target_vpc_internet_gateway.id}"
}

output "created_internet_gateway_arn" {
    value = "${aws_internet_gateway.target_vpc_internet_gateway.arn}"
}

output "created_public_subnet_id" {
    value = "${aws_subnet.public_subnet_main.id}"
}

output "created_public_subnet_arn" {
    value = "${aws_subnet.public_subnet_main.arn}"
}

output "created_private_subnet_id" {
    value = "${aws_subnet.public_subnet_main.id}"
}

output "created_private_subnet_arn" {
    value = "${aws_subnet.public_subnet_main.arn}"
}