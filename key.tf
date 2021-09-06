# Degine a new RSA key.
resource "tls_private_key" "lun_test_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a new RSA key-pair for the new RSA key.
resource "aws_key_pair" "lun_test_key" {
  key_name   = "lun_test_key"
  public_key = tls_private_key.lun_test_key.public_key_openssh

# Save the private key locally and update it's permissions for SSH access to the EC2 host.
	provisioner "local-exec" { 
  command = <<EOT
	    echo '${tls_private_key.lun_test_key.private_key_pem}' > ./luno_test_key.pem
      chmod 400 ./luno_test_key.pem
  EOT
  }
  
}