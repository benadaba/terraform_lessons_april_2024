# 03. vpc
resource "aws_vpc" "our_own_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostname
  enable_dns_support   = true

  tags = {
    Name = "vpc-created-from-terraform"
  }
}

# 04. public subnet1
resource "aws_subnet" "pub_sub_1" {
  vpc_id                  = aws_vpc.our_own_vpc.id
  cidr_block              = var.pub_sub_1_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-1-tf-dp"
  }
}

# 04b. public subnet2
resource "aws_subnet" "pub_sub_2" {
  vpc_id                  = aws_vpc.our_own_vpc.id
  cidr_block              = var.pub_sub_2_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-2-tf-dp"
  }
}


# 5a. private subnet1
resource "aws_subnet" "priv_sub_1" {
  vpc_id                  = aws_vpc.our_own_vpc.id
  cidr_block              = var.priv_sub_1_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "priv-sub-1-tf-dp"
  }
}

# 5b. private subnet2
resource "aws_subnet" "priv_sub_2" {
  vpc_id                  = aws_vpc.our_own_vpc.id
  cidr_block              = var.priv_sub_2_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "priv-sub-2-tf-dp"
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
    Name = "dp-pub_rtb_1-tf"
  }
}


#07  igw
resource "aws_internet_gateway" "our_internet_gw" {
  vpc_id = aws_vpc.our_own_vpc.id

  tags = {
    Name = "our_internet_gw-tf"
  }
}

#08. pub routeble public subnet 1 association
resource "aws_route_table_association" "pub_rtb_1_pub_sub_1_assoc" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.pub_rtb_1.id
}

#08b.  pub routeble public subnet 2 association
resource "aws_route_table_association" "pub_rtb_1_pub_sub_2_assoc" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.pub_rtb_1.id
}



resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat_gw.id
  subnet_id     = aws_subnet.pub_sub_1.id

  tags = {
    Name = "dp-NAT-tf"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.our_internet_gw]
}

resource "aws_eip" "eip_nat_gw" {
  domain = "vpc"

  tags = {
    Name = "dp-eip-tf"
  }
}


#11 private route table 
resource "aws_route_table" "priv_rtb_1" {
  vpc_id = aws_vpc.our_own_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "dp-priv-rtb-1"
  }
}

# 12 priv_rtb_1_priv_sub_1_assoc
resource "aws_route_table_association" "priv_rtb_1_priv_sub_1_assoc" {
  subnet_id      = aws_subnet.priv_sub_1.id
  route_table_id = aws_route_table.priv_rtb_1.id
}


# 12b  priv_rtb_1_priv_sub_2_assoc
resource "aws_route_table_association" "priv_rtb_1_priv_sub_2_assoc" {
  subnet_id      = aws_subnet.priv_sub_2.id
  route_table_id = aws_route_table.priv_rtb_1.id
}