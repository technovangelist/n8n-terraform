#!/bin/bash
set -o errexit;
set -o pipefail;
set -o nounset;
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sleep 10
sudo chmod +x /usr/local/bin/docker-compose
newgrp docker
sudo usermod -aG docker ec2-user
sudo service docker start
sudo chkconfig docker on
sudo yum install -y git
mkdir /home/ec2-user/n8n
sudo /usr/local/bin/docker-compose up -d &
touch /home/ec2-user/provisioncomplete

