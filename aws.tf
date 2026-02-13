provider "aws" {
  region = "us-east-1"
}

resource "aws_ec2_instance" "webserver" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.medium"

  tags = {
    Name = "webserver"
  }
}