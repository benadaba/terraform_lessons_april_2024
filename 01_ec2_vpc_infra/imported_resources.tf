# import {
#   to = aws_instance.instance_3
#   id = "i-0a81c45b11e97a05b"
# }


# resource "aws_instance" "instance_3" {
#   #configuration
# }




resource "aws_instance" "instace_1" {
    ami                                  = "ami-03ceeb33c1e4abcd1"
    instance_type                        = "t2.medium"
    tags                                 = {
        "Environment" = "production"
        "Name"        = "Ec2-created_WITH-TERRAFORM"
    }
    
}


# terraform import aws_instance.web i-12345678
resource "aws_instance" "instance_2" {
    ami                                  = "ami-03ceeb33c1e4abcd1"
    instance_type                        = "t2.medium"
    tags                                 = {
        "Name" = "MightyInstance-Terraform"
    }
}