#!/bin/bash
set -o errexit;
set -o pipefail;
set -o nounset;
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user
newgrp docker
sudo chkconfig docker on
sudo yum install -y git
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mkdir /home/ec2-user/n8n
touch /home/ec2-user/provisioncomplete
docker-compose up -d &

