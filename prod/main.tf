module "ec2-infra-prod"{
    source = "../01_ec2_vpc_infra"
    ec2_config = var.ec2_config
}

module "vpc_infra_2"{
    source = "../02_vpc_infra_2"
    key_name = "datapandas-devops-keypair-us-west-1"
    environment = var.environment
     region = var.region
     ec2_config = var.ec2_config
}