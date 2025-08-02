#!/bin/bash

sudo apt update
sudo apt install openjdk-17-jdk -y

mkdir -p /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

sudo apt update
sudo apt install fontconfig openjdk-17-jre -y
sudo apt install jenkins -y