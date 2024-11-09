# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.15.0"
# }


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

#   azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] #my-vpc-public-eu-west-1b
  public_subnet_names = ["pub-sub-1"]
  public_subnet_enable_resource_name_dns_a_record_on_launch  = false


#   enable_nat_gateway = true
#   enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}