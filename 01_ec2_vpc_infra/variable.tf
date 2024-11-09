variable "region" {
  description = "region where the aws instance will be created"
  default     = "eu-west-2"
}

# variable "ami"{
#   description = "This is the ami used to create the instance"
#   default = "ami-0acc77abdfc7ed5a6"
# }

# string datatype
variable "instance_type" {
  description = "the instance type of the ec2"
  default     = "t2.micro"
}

# number datatype
variable "instance_count"{
  type = number
  default = 2
}

# boolean data type
variable "enable_dns_hostname"{
  type = bool
  default = true
}

# list datatype
variable "ports_list" {
   type= list(number)
   default = [80,443,22,8080,0]
}

# map datatype
variable "ports_map"{
   type= map(number)
   default = {"http": 80,
               "https": 443,
               "ssh": 22,
               "jenkins": 8080
              }
}

# set data type
variable "allowed_ip_addresses"{
  type = set(string)
  default = ["192.168.1.1", "172.168.0.2"]
}

# object datatype
variable "ec2_config"{
   type = object({
       instance_type = string
       instance_count = number
       enable_logging = bool
       tags = map(string)
   })
   
  #  default = {
  #   instance_type  = ""
  #   instance_count = 0
  #   enable_logging = false
  #   tags = {}
  #  }
   default = {
       instance_type = "t2.medium"
       instance_count = 5
       enable_logging = false
       tags = {"Name": "Ec2-created_WITH-TERRAFORM",
               "Environment": "production"
              }
   }
}

# tuple datatype
variable "mixed_tuple"{
 type = tuple([string, number, bool])
 default = ["eu-west-2", 2, true]
}


variable "key_name" {
  default  = ""
}
