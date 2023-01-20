terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "HowLight"
 }
}

 # Add AWS public subnet
 
 resource "aws_subnet" "aws-subnet-public_1" {
 cidr_block = "10.0.1.0/24"
 vpc_id            = "${aws_vpc.main.id}"
 availability_zone = "eu-central-1a"
 map_public_ip_on_launch = "true"
 
 tags = {
    Name            = "how_light_public_1"
  }
 }
 
 resource "aws_subnet" "aws-subnet-public_2" {
 cidr_block = "10.0.2.0/24"
 vpc_id            = "${aws_vpc.main.id}"
 availability_zone = "eu-central-1b"
 map_public_ip_on_launch = "true"
 
 tags = {
    Name            = "how_light_public_2"
  }
 }
 
 # Add AWS private subnet
 
resource "aws_subnet" "aws-subnet-private_1" {
 cidr_block = "10.0.3.0/24"
 vpc_id            = "${aws_vpc.main.id}"
 availability_zone = "eu-central-1a"
 
 tags = {
    Name            = "how_light_private_1"
  }
 }
 
 resource "aws_subnet" "aws-subnet-private_2" {
 cidr_block = "10.0.4.0/24"
 vpc_id            = "${aws_vpc.main.id}"
 availability_zone = "eu-central-1b"
 
 tags = {
    Name            = "how_light_private_2"
  }
 }
 
 # Add AWS internet gateway
 resource "aws_internet_gateway" "how_light_internet_gateway" {
    vpc_id = "${aws_vpc.main.id}"
    tags = {
        Name            = "internet-gateway"
    }
}

resource "aws_network_acl" "acl-private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.aws-subnet-private_1.id, aws_subnet.aws-subnet-private_2.id]
  
  
  ingress {
    cidr_block = "0.0.0.0/0"
    action    = "Deny"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    rule_no   = 200

  }
  
  egress {
    cidr_block = "0.0.0.0/0"
    action    = "Allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    rule_no   = 200

  }
  
  

  tags = {
    Name = "acl-private"
  }
}



# Create security group
resource "aws_security_group" "howlight-web-sg" {
  name                = "web_sg"
  description         = "Security Group for VPC"
  vpc_id              = aws_vpc.main.id

  tags = {
    Name            = "howlight-web_sg"
  }

  # allow traffic for ssh on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["23.111.202.142/32", "23.111.123.20/32", "23.111.123.15/32", "23.111.123.23/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["23.111.202.142/32", "23.111.123.20/32", "23.111.123.15/32", "23.111.123.23/32"]
  }
 
  # allow egress traffic 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEVAa67nfRw2GfyWknxhnkwtDeqcn4MtQ0xuWU8CmlGP01foGshsbqRln0Jk4kmmD9/jVxhPNa3ONz/eJ1nUsBNz5yoG79wuNkS9pFFECJUBgG5dylyByVupCYSo3ngjFw6yLXHWe2rIxn8MJeilycZW5jGwZtS/7E3N5f9N3wHgXTA1yFqUpwvu6DMubhzoFafKv/uwgaCmihogl3a9OxMHHzE/nWhDkAH8AzUsweA6pnjsnf4OR2G0QvOpOxbNIMVF++WUEEgE+YOg/Y5mBt61dxcOVlQGIsevgaYUL1dJQsBt70d8z1m1aSEweIGYIg+r3xzVjugC/0kXLElphJZZFiGKsk/BgxXLgep0j+HAn1CUQ3pNSLXejabW8oguYtxMoWP4OkLK2UjamfgI1b56zPKOYNVvh/VIkVlL1tQWiTOX/HBqGoJoNu4+XTB/SqZD2j1yM3DdhgPdS2AIiDVbWefwPP82cUltTUcNTEZB2arB8GWFO1P+ts/zWoMOE= belev@DESKTOP-C9NNOPT"
}