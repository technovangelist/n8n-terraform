

resource "null_resource" "setup" {
  provisioner "local-exec" {
    command = "sed -i '' '/${var.ipaddress}/d'  ~/.ssh/known_hosts"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.34"
    }
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.keyname
  public_key = file("${var.keyname}.pub")
}
provider "aws" {
  region = var.region

}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
  request_headers = {
    Accept = "application/text"
  }
}

resource "aws_vpc" "n8n-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "n8n"
  }
}

resource "aws_subnet" "n8n-subnet" {
  vpc_id                  = aws_vpc.n8n-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.az
  tags = {
    Name = "n8n"
  }
}

resource "aws_internet_gateway" "n8n-igw" {
  vpc_id = aws_vpc.n8n-vpc.id
  tags = {
    Name = "n8n"
  }
}

resource "aws_route_table" "n8n-crt" {
  vpc_id = aws_vpc.n8n-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.n8n-igw.id
  }
  tags = {
    Name = "n8n"
  }
}

resource "aws_route_table_association" "n8n-crta-subnet" {
  subnet_id      = aws_subnet.n8n-subnet.id
  route_table_id = aws_route_table.n8n-crt.id
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.n8n.id
  allocation_id = var.elasticipalloc
}
resource "aws_security_group" "n8n-sg" {
  name        = "n8n-sg"
  description = "Security group created for n8n on EC2"
  vpc_id      = aws_vpc.n8n-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "n8n"
  }

}

resource "aws_instance" "n8n" {
  ami                    = "ami-0518bb0e75d3619ca"
  availability_zone      = var.az
  subnet_id              = aws_subnet.n8n-subnet.id
  vpc_security_group_ids = [aws_security_group.n8n-sg.id]
  instance_type          = "t2.micro"
  user_data              = templatefile("install_n8n.sh.tpl", {})
  key_name               = aws_key_pair.ssh-key.key_name
  tags = {
    Name = "n8n"
  }
  provisioner "file" {
    source      = ".env"
    destination = "/home/ec2-user/.env"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("n8n")
      host        = self.public_dns
    }
  }
  provisioner "file" {
    source      = "n8n.docker-compose.yaml"
    destination = "/home/ec2-user/docker-compose.yaml"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("n8n")
      host        = self.public_dns
    }
  }

}

output "ssh" {
  description = "SSH to the IP Address"
  value       = "ssh -i ./n8n ec2-user@${var.ipaddress} -o StrictHostKeyChecking=no"
}
