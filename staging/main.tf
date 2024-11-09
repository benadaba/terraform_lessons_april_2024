module "ec2-infra-staging"{
    source = "../01_ec2_vpc_infra"
}

module "vpc-infra-dev" {
    source = "../02_vpc_infra_2"
    region = var.region
    environment = var.environment
}