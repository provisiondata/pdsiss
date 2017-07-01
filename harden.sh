#!/bin/bash
# Centos 7 Hardening 

yum makecache fast 
yum update -y
yum install -y epel-release
yum install -y yum-utils wget
yum install -y fail2ban-firewalld
yum update -y
yum clean all

systemctl stop NetworkManager.service
systemctl disable NetworkManager.service

echo "search mgmt.pdsint.net" > /etc/resolv.conf && \
echo "nameserver 199.60.252.136" >> /etc/resolv.conf && \
echo "nameserver 199.185.139.143" >> /etc/resolv.conf

echo "[sshd]" > /etc/fail2ban/jail.local
echo "enabled = true" >> /etc/fail2ban/jail.local

systemctl enable fail2ban
systemctl start fail2ban
