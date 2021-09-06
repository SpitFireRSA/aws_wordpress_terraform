# This file creates and defines the required resources in the new AWS VPC.

# Create the new RDS MySQL database instance.
resource "aws_db_instance" "lun_rds" {
  allocated_storage = 20
  max_allocated_storage = 100
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7.34"
  instance_class = "db.t3.micro"
  name = "${var.db_name}"
  username = "${var.db_user}"
  password = "${var.db_pass}"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  db_subnet_group_name = aws_db_subnet_group.lun_subnetgroup_database.name
  vpc_security_group_ids = [aws_security_group.lun_sg_rdb.id]
  skip_final_snapshot = true

# Save the new RDS database address as a variable to a local hidden file.
  provisioner "local-exec" {
    command = "echo 'db_host=${aws_db_instance.lun_rds.address}' > .var_db_host"
  }

}

# Create the EC2 instance with Wordpress docker deployment.
resource "aws_instance" "lun_ec2" {
  depends_on = [aws_internet_gateway.lun_gateway, aws_db_instance.lun_rds]
  ami = "ami-0edec67949fd25461"
  instance_type = "t3.micro"
  key_name = aws_key_pair.lun_test_key.key_name
  subnet_id = aws_subnet.lun_subnet_private.id
  vpc_security_group_ids = [aws_security_group.lun_sg_private.id]

# Save the new EC2 DNS name as a variable to a local hidden file.
  provisioner "local-exec" {
    command = "echo 'wp_url=${aws_instance.lun_ec2.public_dns}' > .var_wp_url"
  }

# Copy the file with our EC2 DNS name variable to the new EC2 instance by SSH.
  provisioner "file" {
    source = ".var_wp_url"
    destination = "/tmp/var_wp_url"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.lun_test_key.private_key_pem
      host = aws_instance.lun_ec2.public_ip
    }

  }

# Copy the file with our RDS database name variable to the new EC2 host by SSH.
  provisioner "file" {
    source = ".var_db_host"
    destination = "/tmp/var_db_host"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.lun_test_key.private_key_pem
      host = aws_instance.lun_ec2.public_ip
    }

  }

# Copy the file with our wordpress variables to the new EC2 instance host by SSH.
  provisioner "file" {
    source = "variables.auto.tfvars"
    destination = "/tmp/wp_vars"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.lun_test_key.private_key_pem
      host = aws_instance.lun_ec2.public_ip
    }

  }

# Copy the SQL file with customization update to the new EC2 host by SSH.
  provisioner "file" {
    source = "update.sql"
    destination = "/tmp/update.sql"
    
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.lun_test_key.private_key_pem
      host = aws_instance.lun_ec2.public_ip
    }

  }

# Copy the script to bootstrap our EC2 instance host by SSH.
  provisioner "file" {
    source = "ec2_bootstrap.sh"
    destination = "/tmp/ec2_bootstrap.sh"
    
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.lun_test_key.private_key_pem
      host = aws_instance.lun_ec2.public_ip
    }

  }  

# Execute the EC2 bootstrap script by SSH.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ec2_bootstrap.sh",
      "/tmp/ec2_bootstrap.sh",
    ]
    
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = tls_private_key.lun_test_key.private_key_pem
      host = aws_instance.lun_ec2.public_ip
    }

  }

}  
