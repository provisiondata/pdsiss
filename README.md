# Shell Scripts

Miscelaneous CentOS 7 shell scripts for the PDSI networking environment

> All scripts should be written so that they can be run repeatedly.  E.G. If a script 
> fails to run in it's entirety, fix the issue and run it again.

## harden.sh
Basic hardening for internal servers (non-public facing)
* Set DNS resolvers to our internal caching resolvers
* Install fail2ban and set it to monitor SSH
* Disable root login (Console and SSH.  Use `su` or `sudo`)
* Set ssh login legal banner
* Restrict `/root` directory to `root` user
* Set minimum password length
* Set default password hashing algorithm to SHA-512
* Kick inactive users after 20 minutes
* Restrict `cron` and `at` to `root` user.

**Run as root:**
```
# curl -sL https://raw.githubusercontent.com/provisiondata/pdsiss/master/harden.sh | bash -
```
Don't forget to add the `pdsiroot` user and record the password in KeePass:

```
# useradd pdsiroot
# passwd pdsiroot
# usermod -aG wheel pdsiroot
```