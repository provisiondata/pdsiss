#!/bin/bash
# Basic Centos 7 Hardening 
# curl -sL https://raw.githubusercontent.com/provisiondata/pdsiss/master/harden.sh | bash -

if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
fi

yum update -y
yum install -y epel-release yum-utils fail2ban-firewalld rsyslog wget vim 
yum clean all

systemctl stop NetworkManager.service
systemctl disable NetworkManager.service

echo "search mgmt.pdsint.net" > /etc/resolv.conf && \
echo "nameserver 208.73.56.28" >> /etc/resolv.conf && \
echo "nameserver 199.60.252.143" >> /etc/resolv.conf && \
echo "nameserver 208.73.56.29" >> /etc/resolv.conf && \
echo "nameserver 199.185.139.143" >> /etc/resolv.conf

echo "[sshd]" > /etc/fail2ban/jail.local
echo "enabled = true" >> /etc/fail2ban/jail.local

systemctl enable fail2ban
systemctl start fail2ban

echo "Root cannot login directly. Use su or sudo."
echo "tty1" > /etc/securetty
echo "Disable Root SSH Login"
sed -ri "s/^#?PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
echo "Set login banner"
curl -sL https://raw.githubusercontent.com/provisiondata/pdsiss/master/banner -o /etc/ssh/banner
sed -ri "s/^#?Banner.*/Banner \/etc\/ssh\/banner/g" /etc/ssh/sshd_config
systemctl restart sshd.service

echo "Restrict /root directory to root user"
chmod 700 /root

echo "Minimum passwords length is 8"
sed -i 's/PASS_MIN_LEN\s+0/PASS_MIN_LEN 8/g' /etc/login.defs
echo "Changed password encryption type to SHA-512"
authconfig --passalgo=sha512 --update
echo "Existing users will need to change their password after next login"
for i in `cat /etc/shadow | awk -F: '{if ( $1 != "root" && $1 != "pdsiroot" && $2 ~ /^!?[[:alnum:]\.\/\$]/ ) print $1}'`
do
    chage -d0 $i <<<$i
done

echo "Kick inactive users after 20 min."
echo "readonly TMOUT=1200"> /etc/profile.d/os-security.sh
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

echo "Forward syslog to Graylog"
echo "\$template GRAYLOGRFC5424,\"<%PRI%>%PROTOCOL-VERSION% %TIMESTAMP:::date-rfc3339% %HOSTNAME% %APP-NAME% %PROCID% %MSGID% %STRUCTURED-DATA% %msg%\n\"" > /etc/rsyslog.d/90-graylog2.conf
echo "*.* @10.248.31.20:1514;GRAYLOGRFC5424" >> /etc/rsyslog.d/90-graylog2.conf
systemctl restart rsyslog.service
