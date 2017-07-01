#!/bin/bash
# Basic Centos 7 Hardening 

yum makecache fast 
yum update -y
yum install -y epel-release
yum install -y yum-utils wget git fail2ban-firewalld
yum update -y
yum clean all

systemctl stop NetworkManager.service
systemctl disable NetworkManager.service

echo "search mgmt.pdsint.net" > /etc/resolv.conf && \
echo "nameserver 199.60.252.143" >> /etc/resolv.conf && \
echo "nameserver 199.185.139.143" >> /etc/resolv.conf

echo "[sshd]" > /etc/fail2ban/jail.local
echo "enabled = true" >> /etc/fail2ban/jail.local

systemctl enable fail2ban
systemctl start fail2ban

echo "Root cannot login directly. Use su or sudo."
echo "tty1" > /etc/securetty
echo "Disable Root SSH Login"
sed -ri "s/^#?PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
echo "Restrict /root directory to root user"
chmod 700 /root

echo "Minimum passwords length is 8"
sed -i 's/PASS_MIN_LEN\s+0/PASS_MIN_LEN 8/g' /etc/login.defs
echo "Change password encryption type to sha512"
authconfig --passalgo=sha512 --update

echo "Kick inactive users after 20 min."
echo "readonly TMOUT=1200">> /etc/profile.d/os-security.sh
echo "readonly HISTFILE" >> /etc/profile.d/os-security.sh
chmod +x /etc/profile.d/os-security.sh

echo "Restrict cron to root and /etc/cron.allow"
touch /etc/cron.allow
chmod 600 /etc/cron.allow
awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/cron.deny
echo "Restrict at to root and /etc/at.allow"
touch /etc/at.allow
chmod 600 /etc/at.allow
awk -F: '{print $1}' /etc/passwd | grep -v root > /etc/at.deny
