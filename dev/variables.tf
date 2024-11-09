variable "region"{
    type = string
    default = "eu-west-2"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "ec2_config"{
   type = object({
       instance_type = string
       instance_count = number
       enable_logging = bool
       tags = map(string)
   })
   
   default = {
       instance_type = "t2.micro"
       instance_count =1
       enable_logging = false
       tags = {"Name": "Ec2-created_WITH-TERRAFORM",
               "Environment": "dev"
              }
   }

}