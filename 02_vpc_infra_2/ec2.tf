

# 01. ec2 instace 1
resource "aws_instance" "my-own-name-i-gave" {
  count = 4
  ami                    = data.aws_ami.special_ami.id
  instance_type          = var.ec2_config["instance_type"] #var.ec2_config.instance_type
  key_name               = var.key_name != "" ?  var.key_name : null
  subnet_id              = aws_subnet.pub_sub_1.id
  vpc_security_group_ids = [aws_security_group.security_grp_1.id]
  user_data              = file("${path.module}/scripts/userdatascript1.sh")
  tags = {
    Name = "PUBLIC_SUBNET_INSTANCE_TF"
  }
}

# 02. ec2 instace 2
resource "aws_instance" "my-own-name-i-gave2" {
  count = 2
  ami           = data.aws_ami.special_ami.id
  subnet_id     = aws_subnet.priv_sub_1.id
  user_data     = file("${path.module}/scripts/userdatascript1.sh")
  instance_type =  var.ec2_config["instance_type"]
  key_name      = var.key_name != "" ?  var.key_name : null
  vpc_security_group_ids = [aws_security_group.security_grp_1.id]
  tags = {
    Name        = "PRIVATE_SUBNET_INSTANCE_TF"
    Environment = var.environment
  }
}

#01.1 
resource "aws_instance" "check_ec2-has-pub-ip" {
  ami                    = data.aws_ami.special_ami.id
  instance_type          =  var.ec2_config["instance_type"]
  user_data              = file("${path.module}/scripts/userdatascript1.sh")
  key_name               = var.key_name != "" ?  var.key_name : null
  subnet_id              = aws_subnet.priv_sub_1.id
  vpc_security_group_ids = [aws_security_group.security_grp_1.id]

  tags = {
    Name = "PRIVATE_SUBNET_INSTANCE2_TF"
  }
}



# 05. security group
# dynamic block
resource "aws_security_group" "security_grp_1" {
  name        = "security_grp_1-tf"
  description = "Allow ssh , http, https"
  vpc_id      = aws_vpc.our_own_vpc.id

  #inbound traffic
  dynamic ingress {

    for_each = var.ports_map

    content {
    description = ingress.key
    from_port   = ingress.value  
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = var.all_traffic_cidr
    } 
  }


  
  egress {
    from_port   = var.ports_map["all"] #0
    to_port     = var.ports_map["all"] #0
    protocol    = "-1"
    cidr_blocks = var.all_traffic_cidr
  }

  tags = {
    Name = local.tags.security_grp_1-name
  }
}










#static version
# # 05. security group
# resource "aws_security_group" "security_grp_1" {
#   name        = "security_grp_1-tf"
#   description = "Allow ssh , http, https"
#   vpc_id      = aws_vpc.our_own_vpc.id

#   #inbound traffic
#   ingress {
#     description = "TLS from VPC https"
#     from_port   = var.ports_map.https    #443
#     to_port     = var.ports_map["https"] #443
#     protocol    = "tcp"
#     cidr_blocks = var.all_traffic_cidr
#   }


#   ingress {
#     description = "http"
#     from_port   = var.ports_map.http    #80
#     to_port     = var.ports_map["http"] #80
#     protocol    = "tcp"
#     cidr_blocks = var.all_traffic_cidr
#   }

#   ingress {
#     description = "ssh"
#     from_port   = var.ports_list[2]
#     to_port     = var.ports_list[2]
#     protocol    = "tcp"
#     cidr_blocks = var.all_traffic_cidr
#   }

#    ingress {
#     description = "jenkins"
#     from_port   = var.ports_list["jenkins"]
#     to_port     = var.ports_list["jenkins"]
#     protocol    = "tcp"
#     cidr_blocks = var.all_traffic_cidr
#   }

#    ingress {
#     description = "sonar"
#     from_port   = var.ports_list["sonar"]
#     to_port     = var.ports_list["sonar"]
#     protocol    = "tcp"
#     cidr_blocks = var.all_traffic_cidr
#   }

#   egress {
#     from_port   = var.ports_list[4] #0
#     to_port     = var.ports_list[4] #0
#     protocol    = "-1"
#     cidr_blocks = var.all_traffic_cidr
#   }

#   tags = {
#     Name = local.tags.security_grp_1-name
#   }
# }




#  dynamic ingress {


#     content {
#         description = "jenkins"
#         from_port   = var.ports_list["jenkins"]
#         to_port     = var.ports_list["jenkins"]
#         protocol    = "tcp"
#         cidr_blocks = var.all_traffic_cidr

#     }
#   }