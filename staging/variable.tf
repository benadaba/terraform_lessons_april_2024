variable "region"{
    type = string
    default = "us-east-1"
}

variable "environment" {
  type = string
  default = "staging"
}

variable "ec2_config"{
   type = object({
       instance_type = string
       instance_count = number
       enable_logging = bool
       tags = map(string)
   })
   
   default = {
       instance_type = "t1.micro"
       instance_count =2
       enable_logging = true
       tags = {"Name": "Ec2-created_WITH-TERRAFORM",
               "Environment": "staging"
              }
   }

}