provider "aws" {
  region = "ap-south-1"
}


resource "aws_security_group" "webserver_security_group" {
  name        = "webserver_security_group"
  description = "control access to the web server"
}

# allow http access on port 80 from all addresses/ports
resource "aws_security_group_rule" "ingress_http" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

# allow http access on port 443 from all addresses/ports
resource "aws_security_group_rule" "ingress_https" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

# allow ssh access on port 22 from all addresses/ports
resource "aws_security_group_rule" "ingress_https" {
  security_group_id = "${aws_security_group.webserver_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
}


data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-wordpress-5.0.2-1-linux-ubuntu-*"] # value name should be same as image name in ec2 
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.wordpress.id}"
  instance_type = "t2.micro"

  security_groups = [
    "${aws_security_group.webserver_security_group.name}",
  ]
  
  tags = {
    Name = "Securih-wordpress"
  }
}