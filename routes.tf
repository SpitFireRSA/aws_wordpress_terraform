# This file defines the networking for newly created subnets.

# Creating the new internet gateway in our new VPC.
resource "aws_internet_gateway" "lun_gateway" {
  vpc_id =  aws_vpc.lun_test_vpc.id
}

# Assign the internet gateway to the new routes table as a gateway to the internet.
resource "aws_default_route_table" "lun_route_table" {
  default_route_table_id = aws_vpc.lun_test_vpc.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.lun_gateway.id
    }
}

# Associate the new routes table with the private subnet.
resource "aws_route_table_association" "associate_private_subnet" {
  subnet_id      = aws_subnet.lun_subnet_private.id
  route_table_id = aws_default_route_table.lun_route_table.id
}

# Associate the new routes table with the first RDS database subnet.
resource "aws_route_table_association" "associate_database_subnet_01" {
  subnet_id      = aws_subnet.lun_subnet_database_01.id
  route_table_id = aws_default_route_table.lun_route_table.id
}

# Associate the routes table with the second RDS database subnet.
resource "aws_route_table_association" "associate_database_subnet_02" {
  subnet_id      = aws_subnet.lun_subnet_database_02.id
  route_table_id = aws_default_route_table.lun_route_table.id
}