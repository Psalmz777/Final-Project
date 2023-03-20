#!/bin/bash

# Install Jenkins
sudo apt-get update
sudo apt install openjdk-8-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Git
sudo apt-get update
sudo apt-get install -y git

# Install Terraform
sudo apt-get update
sudo apt-get install -y unzip
wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
unzip terraform_1.1.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install Kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Configure Jenkins


echo "Jenkins is now installed and ready to use."
