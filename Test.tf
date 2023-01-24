terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "test" {
  ami                    = "ami-0ceecbb0f30a902a6"
  instance_type          = "t2.micro"
  #subnet_id              = "${aws_subnet.aws-subnet-public_2.id}"
  vpc_security_group_ids = [aws_security_group.test.id]
  #key_name = "deployer-key"
  user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=curl http://169.254.169.254/latest/meta-data/local-ipv4
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
echo "Hello World" > /var/www/html/index.html
EOF
}

resource "aws_security_group" "sg_test" {
  name        = "sg_test"
  description = "Security Group for VPC"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "sg_test"
  }
}


