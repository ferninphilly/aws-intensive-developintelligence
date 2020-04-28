provider "aws" {
  profile    =  var.profile
  region     =  var.region
}

resource "aws_instance" "myfirstec2" {
  ami           = var.ec2type
  instance_type = "t2.micro"
  key_name = "myec2key"
}

resource "aws_key_pair" "ec2key" {
  key_name   = "myec2key"
  public_key = file("./keys/practicekey.pub")
}