
resource "aws_instance" "linux_minimal" {
  ami                    = "ami-0d500797138456fbb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.howlight-web-sg.id]
  subnet_id              = "${aws_subnet.aws-subnet-public_1.id}"
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
EOF

}

resource "aws_instance" "linux_minimal_2" {
  ami                    = "ami-0d500797138456fbb"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.aws-subnet-public_2.id}"
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
EOF

}