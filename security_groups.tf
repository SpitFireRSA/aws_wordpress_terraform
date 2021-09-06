# This file creates and defines rule for the security groups required.

# Creating a new security group for private subnet.
resource "aws_security_group" "lun_sg_private" {
  name        = "lun_sg_private"
  description = "Allow SSH and HTTP"
  vpc_id      =  aws_vpc.lun_test_vpc.id                   

  ingress {
    description = "Ingress - SSH - Public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "Ingress - HTTP - Public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Egress - All - Public"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Creating a new security group for database subnet.
resource "aws_security_group" "lun_sg_rdb" {
  name        = "lun_sg_rds"
  description = "Allow ingress from private subnet."
  vpc_id      =  aws_vpc.lun_test_vpc.id                   

  ingress {
    description = "Ingress - MySQL - Private"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.lun_subnet_private.cidr_block]
  }

  egress {
    description = "Egress - All - Public"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

}