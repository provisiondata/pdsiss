#!/bin/bash -u
# Centos 7 Install Docker

firewall-cmd --permanent --new-service=docker
firewall-cmd --permanent --service=docker --add-port=2377/tcp
firewall-cmd --permanent --service=docker --add-port=4789/tcp
firewall-cmd --permanent --service=docker --add-port=7946/tcp
firewall-cmd --permanent --service=docker --add-port=7946/udp
firewall-cmd --permanent --zone=public --add-service=docker
firewall-cmd --reload

groupadd docker
usermod -aG docker $USER

yum install -y git device-mapper-persistent-data lvm2  
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce
yum clean all

systemctl enable docker
systemctl start docker
