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

