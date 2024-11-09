module "ec2-infra" {
    source = "../01_ec2_vpc_infra"
    region = var.region
    ec2_config = var.ec2_config
}

module "vpc-infra-dev" {
    source = "../02_vpc_infra_2"
    environment = var.environment
    region = var.region
    ec2_config = var.ec2_config
     
}

module "meta-argument" {
  source = "../03_meta_arguments"
}


output "public_ip_address_of" {
  value = module.ec2-infra.ipaddress_of_our_public_webapp
}

output "meta-arg-s3" {
    value = module.meta-argument.s3-bucket-name
}