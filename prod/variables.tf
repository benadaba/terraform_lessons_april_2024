variable "region" {
  type = string
  default = "us-west-1"
}

variable "environment" {
  type = string
  default = "prod"
}


variable "ec2_config"{
   type = object({
       instance_type = string
       instance_count = number
       enable_logging = bool
       tags = map(string)
   })
   
   default = {
       instance_type = "t2.medium"
       instance_count = 5
       enable_logging = false
       tags = {"Name": "Ec2-created_WITH-TERRAFORM",
               "Environment": "production"
              }
   }

}