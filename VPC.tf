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



  tags = {
    Name = "example"
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
    cidr_blocks = ["23.111.202.142/32", "23.111.123.20/32", "23.111.123.15/32", "23.111.123.23/32","192.168.100.18"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["23.111.202.142/32", "23.111.123.20/32", "23.111.123.15/32", "23.111.123.23/32","192.168.100.18"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  # allow egress traffic 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "test" {
  name                = "test"
  description         = "Security Group for VPC"


  tags = {
    Name            = "test"
  }

  # allow traffic for ssh on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow egress traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  }
/*resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.how_light_internet_gateway.id
  }
  */

resource "aws_route_table" "rt_how_light_public" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name        = "my-public-routetable"
  }
}
# Create a rout in the roite table, to access public via internet gateway
resource "aws_route" "how_light_route_igw" {
  route_table_id         = "${aws_route_table.rt_how_light_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.how_light_internet_gateway.id}"
  #depends_on = ["aws_internet_gateway.how_light_internet_gateway"]
}

resource "aws_route_table_association" "rt_association_public_1" {
  subnet_id      = "${aws_subnet.aws-subnet-public_1.id}"
  route_table_id = "${aws_route_table.rt_how_light_public.id}"
  #depends_on = ["aws_route_table.rt_how_light_public"]
}
resource "aws_route_table_association" "rt_association_punlic_2" {
  subnet_id      = "${aws_subnet.aws-subnet-public_2.id}"
  route_table_id = "${aws_route_table.rt_how_light_public.id}"
  #depends_on = ["aws_route_table.rt_how_light_public"]
}
