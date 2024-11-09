# 01. ec2 instace 1
resource "aws_instance" "my-own-name-i-gave" {
  ami           = data.aws_ami.special_ami.id
  instance_type = var.ec2_config["instance_type"]  #var.ec2_config.instance_type
  key_name      = var.key_name != "" ?  var.key_name : null
  subnet_id = aws_subnet.pub_sub_1.id
  vpc_security_group_ids = [aws_security_group.security_grp_1.id]

  tags = {
    Name = local.tags.my-own-name-i-gave-name
  }
}

resource "aws_instance" "five_instances" {
  count = 5
  ami           = data.aws_ami.special_ami.id
  instance_type = var.ec2_config["instance_type"]  #var.ec2_config.instance_type
  key_name      = var.key_name
  

  tags = {
    Name = local.tags.my-own-name-i-gave-name
  }
}

# 02. ec2 instace 2
# resource "aws_instance" "instance_for_our_nexus_app" {
#   ami           = data.aws_ami.special_ami.id
#   instance_type =  var.ec2_config["instance_type"]
#   key_name      = var.key_name
#   tags = {
#     Name = var.ec2_config.tags.Name
#     Environment = var.ec2_config.tags["Environment"]
#   }
# }

#01.1 
resource "aws_instance" "check_ec2-has-pub-ip" {
  ami           = data.aws_ami.special_ami.id
  instance_type =  var.ec2_config["instance_type"]
  key_name      = var.key_name
  subnet_id = aws_subnet.pub_sub_1.id
  vpc_security_group_ids = [aws_security_group.security_grp_1.id]

  tags = {
    Name = local.tags.check_ec2-has-pub-ip-name
  }
}

# 03. vpc
resource "aws_vpc" "our_own_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostname
  enable_dns_support = true

  tags = {
    Name = local.tags.our_own_vpc-name
  }
}

# 04. public subnet1
resource "aws_subnet" "pub_sub_1" {
  vpc_id     = aws_vpc.our_own_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = local.tags.pub_sub_1-name
  }
}

# 05. security group
resource "aws_security_group" "security_grp_1" {
  name        = "security_grp_1-tf"
  description = "Allow ssh , http, https"
  vpc_id      = aws_vpc.our_own_vpc.id
 
 #inbound traffic
  ingress {
    description = "TLS from VPC https"
    from_port   = var.ports_map.https  #443
    to_port     = var.ports_map["https"] #443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   variable "ports_list"{
#    type= list(number)
#    default = [80,443,22,8080]
# }

   ingress {
    description = "http"
    from_port   = var.ports_map.http #80
    to_port     = var.ports_map["http"] #80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = var.ports_list[2]
    to_port     = var.ports_list[2]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.ports_list[4] #0
    to_port     = var.ports_list[4] #0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.tags.security_grp_1-name
  }
}


#06. public route table

resource "aws_route_table" "pub_rtb_1" {
  vpc_id = aws_vpc.our_own_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.our_internet_gw.id
  }

  tags = {
    Name = "main"
  }
}


#07  igw
resource "aws_internet_gateway" "our_internet_gw" {
  vpc_id = aws_vpc.our_own_vpc.id

  tags = {
    Name = "our_internet_gw-tf"
  }
}

#08. routeble subnet association
resource "aws_route_table_association" "pub_rtb_1_pub_sub_1_assoc" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.pub_rtb_1.id
}