terraform {
  required_version = ">= 0.8, <= 0.11.7"
}

provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 3000
}

resource "aws_instance" "example" {
  ami           = "ami-922914f7"
  instance_type = "t2.micro"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name = "CertBookKeyPair"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install --enablerepo=epel -y nodejs
              sudo wget http://bit.ly/2vESNuc -O /home/ec2-user/helloworld.js
              sudo wget http://bit.ly/2vVvT18 -O /etc/init/helloworld.conf
              sudo start helloworld
              EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
