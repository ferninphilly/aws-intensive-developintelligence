variable "region" {
    type = "string"
    description = "This is the region we want to deploy to. If you want to change the region do it here"
    default = "eu-west-1"
}

variable "profile" {
    type= "string"
    description = "This is the string representation of the aws profile we want to use"
    default = "codices"
}

variable "ec2type" {
    type = "string"
    description = "This is the ami for the type of ec2 instance we want to deploy"
    default = "ami-03746875d916becc0"
}

variable "key_pair_name" {
    type = "string"
    description = "The key pair to access our ec2 instance"
    default = "practicekey"
}

