# DevOps Lifecycle Assignment - Abode Software

This project demonstrates implementing a full DevOps lifecycle using **AWS EC2**, **Jenkins**, **Ansible**, **Docker**, and **GitHub Webhooks** for CI/CD.

---

## ✅ Project Goals
- Provision EC2 instances for Jenkins master and slave nodes.
- Set up Ansible for configuration management and automated tool installation.
- Configure Jenkins master and agent nodes.
- Use GitHub with `master` and `develop` branches for Git workflow.
- Automate build and test pipelines triggered by GitHub webhooks.
- Containerize the application using Docker.

---

## 🛠️ Tools & Technologies
- **AWS EC2** 
- **Jenkins**
- **Ansible**
- **Docker**
- **Git & GitHub**
- **GitHub Webhooks**

---

## 🚀 Step-by-Step Implementation

### 1 Create 3 EC2 Instances
- Launch **3 Ubuntu EC2 instances**:
  - `jenkins-master`
  - `slave1`
  - `slave2`
- Open required security group ports:
  - `22` (SSH)
  - `8080` (Jenkins)
  - `80` (Application)

---

### 2️⃣ connect all the ec2 machine
1. **setup-password Less Connection :**
   - run ssh-keygen command to generat id233.pub file and copy this file content 
2. **Slave Machine:**
   - paste the master file content in authorized_key in slaves machine

---

### 3️⃣ install the ansible in Master - Machine 
   - sudo apt install software-properties-common -y
   - sudo add-apt-repository --yes --update ppa:ansible/ansible
   - sudo apt install ansible -y
   - ansible --version

---


### 4️⃣ Enter the Private ip of slaves ip in inventory file 
   --- enter the IPs in hosts file 
   -[slaves] 
   -<private-ip>
   -<private-ip2>

---

### 5️⃣ Create the Playbooks and Execute to Install Configuration Management tools in machine 

  1. **playbook.yaml**
  ---
- name: master
  hosts: localhost
  become: yes
  tasks:
    - name: execute tasks for master
      script: master.sh

- name: slave
  hosts: slaves
  become: true
  tasks:
    - name: execute tasks for slaves
      script: slave.sh

   2. **master.sh**
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

    3. **slave.sh**
    #!/bin/bash

    sudo apt update
    sudo apt install openjdk-17-jdk -y
    sudo apt install docker.io -y

    **Execute playbook**
    ansible playbook playbook.yaml

### 6️⃣ Configure Jenkins 
   access the jenkins <public-ip-msater-jenkin>:8080

  **install plugins**
   Go to Manage Jenkins → Manage Plugins → Available.
   Install: 
   SSH Agent Plugin
   GitHub Integration Plugin

  **Setup Agent Node**
  Manage Jenkins → Nodes and Clouds → New Node
  Create slave1 and slave2
  Use SSH credentials for connection.

### 7️⃣ Initialize Git Workflow
1. **Fork the repository:**
   - Fork [https://github.com/hshar/website.git](https://github.com/hshar/website.git) into your GitHub account.
2. **Clone your fork:**
   ```bash
   git clone https://github.com/Kshitij0253/devops-capstone-one
   cd website

### 8️⃣  Configure GitHub Webhook
 In your forked repository:
 Go to Settings → Webhooks → Add Webhook 
 Payload URL:
 http://<jenkins-master-ip>:8080/github-webhook/

**create two in fork repository ###master### ###Develop###**

### 9️⃣ create a docker file in repository 
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install apache2 -y && apt-get clean
COPY . /var/www/html/
EXPOSE 80
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]



### 🔟 Create Jenkins Jobs
**Job1**: Build
Triggered by commits to both develop and master.

Builds Docker image and runs container.
in script input 
if [ "$(sudo docker ps -aq -f name=c1)" ]; then
    sudo docker rm -f c1
fi

sudo docker build -t job1 .
sudo docker run -itd -p 85:80 --name c1 job1

**Job2** : Test 
Triggered by commits to both develop and master.

Builds Docker image and runs container.
in script input 
if [ "$(sudo docker ps -aq -f name=c1)" ]; then
    sudo docker rm -f c1
fi

sudo docker build -t job1 .
sudo docker run -itd -p 83:80 --name c1 job1


### 1️⃣1️⃣ Test 
 - Push changes to develop or master branch.
 
 - Jenkins should automatically trigger jobs via webhook.

 - Access the application in a browser using the public IP and mapped port.