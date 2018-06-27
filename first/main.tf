terraform {
  required_version = ">= 0.8, <= 0.11.7"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-922914f7"
  instance_type = "t2.micro"
  key_name = "CertBookKeyPair"
}
