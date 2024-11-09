output "ipaddress_of_our_public_webapp" {
  value = aws_instance.check_ec2-has-pub-ip.public_ip
}