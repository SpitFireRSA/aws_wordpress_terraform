# This file creates and defines the VPC and the networks required for each resource.

# Create a new AWS VPC.
resource "aws_vpc" "lun_test_vpc" {
  cidr_block       = "192.168.0.0/16"
  enable_dns_hostnames = true
}

# Create the new private subnet for the EC2 instance. 
resource "aws_subnet" "lun_subnet_private" {
  vpc_id     = aws_vpc.lun_test_vpc.id
  cidr_block = "192.168.101.0/24"
  map_public_ip_on_launch = true
}

# Create the first database subnet.
resource "aws_subnet" "lun_subnet_database_01" {
  vpc_id     = aws_vpc.lun_test_vpc.id
  cidr_block = "192.168.102.0/24"
  availability_zone = "eu-west-1a"
}

# Create the second database subnet in a different availability zone.
resource "aws_subnet" "lun_subnet_database_02" {
  vpc_id     = aws_vpc.lun_test_vpc.id
  cidr_block = "192.168.103.0/24"
  availability_zone = "eu-west-1b"
}

# Create the new database subnet group.
resource "aws_db_subnet_group" "lun_subnetgroup_database" {
  name       = "lun_subnetgroup_database"
  subnet_ids = [aws_subnet.lun_subnet_database_01.id, aws_subnet.lun_subnet_database_02.id]
}
