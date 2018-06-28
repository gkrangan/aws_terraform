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

variable "source_ip" {
  description = "The source IP allowed inbound by the security group"
  default     = "xx.xx.xx.xx/32"

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance-sg"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
#   cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.source_ip}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_security_group_id" {
  value = "${aws_security_group.instance.id}" 
}

output "instance_security_group_id" {
  value = "${aws_security_group.elb.id}" 
}
