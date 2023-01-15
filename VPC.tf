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
 
 tags = {
    Name            = "how_light_public_1"
  }
 }
 
 resource "aws_subnet" "aws-subnet-public_2" {
 cidr_block = "10.0.2.0/24"
 vpc_id            = "${aws_vpc.main.id}"
 availability_zone = "eu-central-1b"
 
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
