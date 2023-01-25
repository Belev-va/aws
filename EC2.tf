
resource "aws_instance" "linux_minimal" {
  ami                    = "ami-0d500797138456fbb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.howlight-web-sg.id]
  subnet_id              = "${aws_subnet.aws-subnet-public_1.id}"
  key_name = "deployer-key"
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
EOF
}

resource "aws_instance" "test" {
  ami                    = "ami-0ceecbb0f30a902a6"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.aws-subnet-public_2.id}"
  vpc_security_group_ids = [aws_security_group.test.id]
  key_name = "deployer-key"
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