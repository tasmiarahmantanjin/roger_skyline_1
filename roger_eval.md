# NETWORK & SECURITY PART

## Usefull commands:

	1. To transfer file from MAC to DEBIAN USER:

```
scp -P 50683 /Users/trahman/Desktop/roger-skyline-1/sudo_right_check.sh tasmia@10.11.199.12:/home/tasmia/sudo_right_check.sh
```


## ⚡️ 1. TO LOGIN as non-root user with SUDO rights:

	1. Go to VM
	2. sudo adduser evan
	3. sudo adduser evan sudo
	4. or edit **/etc/sudoers or **sudo visudo** and add: **evan ALL=(ALL:ALL) NOPASSWD:ALL**
	5. sudo mkdir -p /home/evan/.ssh
	6. sudo scp /home/tasmia/.ssh/authorized_keys /home/evan/.ssh/authorized_keys
	7. sudo chown evan /home/evan/.ssh/authorized_keys
	8. logout from the trahman
	9.  ssh evan@10.11.199.12 -p 50683

## ⚡️ 2. TO TEST IF THE NEW_USER HAS SUDO RIGHTS IS:

	1. sudo cat /var/log/syslog
	2. groups new_user

## ⚡️ 3. TO check DHCP service of VM is deactivated

	1. service --status-all (its not there)
	2. sudo cat /etc/network/interfaces (to cross checck)
	3. sudo ss -tulpn

## ⚡️ 4. TO CHANGE THE NETMASK & RECONNECT IT:

	1. vim /etc/network/interfaces
	2. Change netmask:
	3. netmask 255.255.255.0
	4. sudo /etc/init.d/networking restart
	5. if network is down
	6. sudo ifdown enp0s3 && ifup enp0s3 (to restart network)
	7. logout
	8. Go back to mac terminal: ssh tasmia@10.11.199.12 -p 50683
	9. Successfully reconnect with ssh and port

## ⚡️ 5. TO CEHCK THE SSH PORTS HAS BEEN CHANGED FROM DEFAULT_PORT: 22:

	1. sudo netstat -tulpn | grep LISTEN
	2. ssh root@10.11.199.12 -p 50683 (FROM MAC TERMINAL)

## ⚡️ 6. TO CEHCK THE FIREWAL_RULES

	1. sudo ufw status verbose


## ⚡️ 7. TO CHECK DOS PROTECTION:

	1.We can test if the new conf works with SlowLoris (an HTTP DDOS attack script)
	2. install git: sudo apt-get install git
	3. install SlowLoris: git clone https://github.com/gkbrk/slowloris.git slowloris
	4. go to: cd slowlaries directory (MAC TERMINAL)
	5. python slowloris.py 10.11.199.12 (in the MAC TERMINAL)
	6. Check fail2ban.log that ip is banned from:  sudo tail -F /var/log/fail2ban.log
	7. or iptables --list | head ::::to check if its baned or not
	8. sudo service fail2ban status : TO CHECK IF fail2ban is installed or not
	9. or service --status-all

## ⚡️ 8. TO Check OPEN PORT:

	1. lsof -i -P -n | grep "LISTEN"
	2. sudo nmap -sTU -O (STATIC_IP_ADDRESS) : to check if the port protection is working or not (EXTRA)

## ⚡️ 9. TO CHECK ALL THE ACTIVE SERVICE STATUS:

	1. sudo systemctl list-unit-files --type service | grep enabled
	2. sudo service --status-all (EXTRA)


## ⚡️ 10. TO CHECK SCRIPTS:

	1. **crontab -l** :to see the crontab rules
	2. or **sudo cat /etc/crontab**
	3. sudo cat ~/update.sh


## ⚡️ 11. Test if Email sending works:

	1. sudo cat ~/crontab_monitor.sh
	2. Go to: vim /etc/crontab
	3. Add: anything to /etc/crontab or: touch /etc/crontab
	4. Run: bash cron_monitor.sh
	5. write: mail -u root
	6. or You can check mail in: cat /var/mail/root

# WEB_PART


## ⚡️ 12. TO TEST SSL ON ALL SERVICES:


## ⚡️ 12. TO TEST Check web package

	1. sudo apt list --installed | grep apache

#  Deployment Parts

## ⚡️ 12. TO TEST Check active configuartion

	1. sudo cat /etc/apache2/sites-available/000-default.conf
	2. 