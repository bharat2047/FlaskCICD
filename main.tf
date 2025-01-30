  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "flask_sg" {
  name        = "flask-security-group"
  description = "Security group for Flask server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask application access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-sg"
  }
}

resource "aws_instance" "flask_server" {
  ami                    = "ami-0df8c184d5f6ae949"  
  instance_type         = "t2.micro"
  subnet_id             = "subnet-07eec9e534360858e"  
  vpc_security_group_ids = [sg-04cb5827cbf033696]
  associate_public_ip_address = true
  key_name              = "aws"

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "flask-server"
  }
}


 variable "instance_name" {
description = "Name tag for the EC2 instance"
type = string 
}

output "i-09b66d5f75a7ee5e2" {
  value = aws_instance.flasks_server.id
}

output "184.72.122.111" {
  value = aws_instance.flask_server.public_ip
}

stage (' Create EC2 Instance') {
steps {
script {
sh 'terraform init"
sh """
terraform apply-auto-approve \ 
var= "instance_name=${EC2_NAME}"//
 Dynamically sets the instance name
"""

def publicIp =sh (
script: 'terraform output -raw public_ip",
returnStdout:true).trim()
sh "echo EC2_PUBLIC_IP = ${publicIp} > ec2.properties "
}
}

post {
failure {
echo ' FAILURE; Failed to create EC2 instance'
}
}
}

