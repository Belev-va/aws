
/*
resource "aws_instance" "how_light_ec2_1" {
  ami                    = "ami-0a261c0e5f51090b1"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.aws-subnet-public_2.id}"
  vpc_security_group_ids = ["${aws_security_group.howlight-web-sg.id}"]
  key_name               = "deployer-key"
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo echo "<html> <h1> Server A </h1> </html>" > /var/www/html/index.html
             EOF
}

resource "aws_instance" "test" {
  ami                    = "ami-0a261c0e5f51090b1"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.aws-subnet-public_1.id}"
  vpc_security_group_ids = ["${aws_security_group.howlight-web-sg.id}"]
  key_name = "deployer-key"
  user_data = <<-EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=curl http://169.254.169.254/latest/meta-data/local-ipv4
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
}