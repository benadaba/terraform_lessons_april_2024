terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.0"
    }
    
  }

  backend "s3" {
    bucket = "tfstate-bucket-datapandas"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
  /* required_version = "1.9.8"
  backend "" {
    
  }
  cloud {
    
  }
  language = TF2021
  experiments = [  ] */
  
}


# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = var.region
}


variable "region" {
   description = "the region to provision resources in"
   type = string
  #  default = "eu-west-2"
   default = "us-east-1"
  
}

# variable "ami" {
#   description = "ami for the region"
#   type = string
#   # default = "ami-0acc77abdfc7ed5a6" #eu-west-2
#   default = "ami-06b21ccaeff8cd686" #eu-west-2

# }

locals {
  ssh_instruction =  "ssh -i keypair.pem ubuntu@${aws_instance.web.public_ip}"
  jenkins_url = "curl -v ${aws_instance.web.public_ip}:8080"
  apache_url =  "curl -v ${aws_instance.web.public_ip}:80"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = data.aws_instance.foo.instance_type

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  tags = {
    Name = "EC2-through-Terraform-345"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical #aws
}


output "give_me_instance_ip_address" {

   value = local.ssh_instruction
}

output "what_ami_did_we_use_eventually" {

   value = aws_instance.web.ami
}

output "did_we_match_the_instance_of_the_manual_ec2" {

   value = aws_instance.web.instance_type
}

output "jenkins_server_url" {

   value = local.jenkins_url
}

output "apache_server_url" {

   value = local.apache_url
}


data "aws_instance" "foo" {
  instance_id = "i-057e4bb3e9eba107c"  ## created_manually

  filter {
    name   = "image-id"
    values = ["ami-06b21ccaeff8cd686"]
  }

  filter {
    name   = "tag:Name"
    values = ["manual-ec2-instance"]
  }
}

