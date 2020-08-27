terraform {
  required_providers {
    aws = "~> 3.2"
#      source = "hashicorp/aws"
#       version = "~>= 3.2"
       }
     }
#  }

provider "aws" {
  profile = "default"
  region  = "eu-west-1"

}

resource "aws_key_pair" "example" {
   key_name = "aws-keys"
   public_key = file("~/learn-terraform-aws-instance/terraform.pub")
}

resource "aws_instance" "example" {
   key_name      = aws_key_pair.example.key_name
   ami           = "ami-04c2d1d01e928b8e2" 
#   ami		 = "ami-05dfcc21bfc7c9b02"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0f06c38e935ddba5e"
  vpc_security_group_ids = ["sg-06589d4ac7c54ca89"]

 connection {
  type   = "ssh"
  user  = "ec2-user"
  private_key = file ("~/learn-terraform-aws-instance/terraform")
  host       = self.public_ip
}
#provisioner "local-exec" {

#command = "echo ${aws_instance.example.public_ip} > ip.txt"

provisioner "remote-exec" {
 inline  = [
# "sudo amazon-linux-extras enable nginx1.12",
 "sudo yum -y install nginx",
 "sudo service nginx start",

# To add service to autostart upon reboot/failure. 
 "sudo chkconfig nginx on"
  ]
 }
}
