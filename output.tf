# Output the EC2 instance DNS name when our terraform run has finished.
output "lun_ec2_endpoint" {
  value = aws_instance.lun_ec2.public_dns
}