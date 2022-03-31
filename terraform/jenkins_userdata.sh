#!/bin/bash
sudo apt-get update
sudo apt install docker git default-jre
sudo apt-get install awscli
sudo service docker start
sudo usermod -aG docker ubuntu

# trivy - Security scan image
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy