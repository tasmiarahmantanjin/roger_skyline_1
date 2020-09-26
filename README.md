# Roger-skyline-1
This project, roger-skyline-1 let you install a Virtual Machine, discover the basics about system and network administration as well as a lots of services used on a server machine.

## Summary <a id="summary"></a>

- [roger-skyline-1](#roger-skyline-1)
	- [Summary <a id="summary"></a>](#summary-)
- [Network and Security Part](#network-and-security-part)
	- [1. Virtual Machine Installation <a id="VMinstall"></a>](#1-virtual-machine-installation-)
	- [2. OS Installation Process <a id="OSinstallation"></a>](#2-os-installation-process-)
	- [3. Install Depedency <a id="depedency"></a>](#3-install-depedency-)
	- [4. Configure SUDO <a id="sudo"></a>](#4-configure-sudo-)
	- [5. Setup a static IP <a id="staticIP"></a>](#5-setup-a-static-ip-)
		- [💡 ***NOTE***](#-note)
	- [6. Change SSH default Port](#6-change-ssh-default-port)
		- [💡 ***NOTE***](#-note-1)
	- [7. Setup SSH access with publickeys](#7-setup-ssh-access-with-publickeys)
	- [8. Setup Firewall with UFW. <a id="ufw"></a>](#8-setup-firewall-with-ufw-)
		- [Sources:](#sources)
	- [9. Setup DOS protection with fail2ban. <a id="fail2ban"></a>](#9-setup-dos-protection-with-fail2ban-)
		- [💡 ***NOTE***](#-note-2)
	- [10. Setting up Protection against port scans. <a id="scanSecure"></a>](#10-setting-up-protection-against-port-scans-)
		- [💡 ***NOTE***](#-note-3)
	- [11. Stop the services we don’t need <a id="stopServices"></a>](#11-stop-the-services-we-dont-need-)
	- [12. Script to update all the packages <a id="updateApt"></a>](#12-script-to-update-all-the-packages-)
		- [💡 ***NOTE***](#-note-4)
	- [13 Making a script to warn of all crontab edits](#13-making-a-script-to-warn-of-all-crontab-edits)

# Network and Security Part

## 1. Virtual Machine Installation <a id="VMinstall"></a>

## 2. OS Installation Process <a id="OSinstallation"></a>

1. CD link: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.5.0-amd64-xfce-CD-1.iso
2. I choose `tasmia` as hostname
3. I setup the root password (1234)
4. I create a new non-root user called `tasmia` and his password.
5. Partitioning (Manual, Select the SCSI partition(yes),select, create new, 4.2 GB, Primary,
6. Beginning, finish. Change bootable on, use as ext4,  Make a new partition, Logical, enter, enter. Change to swap, Finish and write changes).
7. I skiped the mirror networking and did it manually letter.
8. I choose not to install desktop environnement, standart utilities
9. I didn't participate in survey
10. Finally I've choose GRUB on the master boot record
11. done
12. Finally, i did mirror networking manually (add update sources to /etc/apt/sources.list https://debgen.simplylinux.ch/)
13. Install all the missing package, like SSH, SUDO.

## 3. Install Depedency <a id="depedency"></a>

As root:

```bash
apt-get update -y && apt-get upgrade -y

apt-get install sudo vim ufw portsentry fail2ban apache2 mailutils -y
```
## 4. Configure SUDO <a id="sudo"></a>

You must create a non-root user to connect to the machine and work.
1. su -
2. Enter password
3. sudo adduser user_name
4. sudo usermod -aG  sudo user_name or sudo adduser user_name sudo
5. or edit /etc/sudoers and add: tasmia ALL=(ALL:ALL) NOPASSWD:ALL

TEST: cat /etc/sudoers

OUTPUT: 
```console
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbi$

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL
tasmia  ALL=(ALL:ALL) NOPASSWD:ALL

# Members of the admin group may gain root privileges

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
```

## 5. Setup a static IP <a id="staticIP"></a>

1. First, we have to edit the file `/etc/network/interfaces` and setup our primary network

2. Now we have to configure this network with a static ip, to do that properly, we will place the network info inside `etc/network/interfaces` & output will look like below after edit

OUTPUT: `cat etc/network/interfaces`
```console
source /etc/network/interfaces.d/*

#The loopback Network interface
auto lo
iface lo inet loopback

#The primary network interface
auto enp0s3
iface enp0s3 inet static
	  address 10.11.199.12
	  netmask 255.255.255.252
	  gateway 10.11.254.254
```
3. You can now restart the network service to make changes effective

```bash
sudo service networking restart
```
4. You can check the result with the following command:

```bash
ip addr
```
### 💡 ***NOTE***

	What is a /30 bit subnet mask?
	I am sure you are used to seeing subnet masks that look like 255.255.255.0. This is a /24 subnet mask in “slash notation”. 
	As you can see, it is much easier to type /24 than it is to type 255.255.255.0. 
	These two are the same because if you translate 255.255.255.0 to binary, 
	you get 11111111 11111111 11111111 00000000, or 24 one’s.
	
	As you know a /24 bit subnet mask has 254 usable IP addresses + 1 for the broadcast + 1 for the network. 
	This is calculated 2^8 (or 2 to the 8th power) = 256 – 2 = 254.

	So what is a /30 bit mask? A /30 bit mask would be 30 one’s, leaving just 2 zero’s that could be used for host addressing. 
	If you apply the hosts formula, you get 2^2 = 4 – 2 = 2 useable IP addresses. 

## 6. Change SSH default Port

1. Go back to root and use any text editor to edit the sshd configuration file
   sudo vim /etc/ssh/sshd_config
2. Change the port number as per your wish
   My port: 50683

### 💡 ***NOTE***

	Change line "Port 22" to "Port 50683" and if this line has "#" take it away
	Port numbers are assigned in various ways, based on three ranges: System Ports (0-1023) this is forbidden to use, User Ports (1024-49151) this should be avoided as well, and the Dynamic and/or Private Ports (49152-65535) this range can be used;
	available information here: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml

3. You can now restart the network service to make changes effective
   sudo service sshd restart or sudo reboot
4. Now we can connect with the host terminal with ssh and port number
   command: ssh tasmia@10.11.199.12 -p 50683

## 7. Setup SSH access with publickeys

1. In this point we need to generate public/private rsa key pair on the host machine(iMac terminal in my case, outside of VM)
2. we can check if there is already rsa_key exists or not in our host computer (command > ls ~/.ssh/id_rsa*)

3. First we have to generate a public/private rsa key pair, on the host machine (Mac OS X in my case).

```bash
ssh-keygen -t rsa
```
This command will generate 2 files `id_rsa` and `id_rsa.pub`

- **id_rsa**:  Our private key, should be keep safely, She can be crypted with a password.
- **id_rsa.pub** Our private key, you have to transfer this one to the server.

Source: Source: https://www.linode.com/docs/security/authentication/use-public-key-authentication-with-ssh/#connect-to-the-remote-server

2. To do that we can use the `ssh-copy-id` command

```bash
ssh-copy-id -i /User/trahman/.ssh/id_rsa.pub tasmia@10.11.199.12 -p 50683
```

The key is automatically added in `~/.ssh/authorized_keys` on the server
Test: go to VM and use `cat /tasmia/.ssh/authorized_keys` to check

> If you no longer want to have type the key password you can setup a SSH Agent with `ssh-add`

3. Edit the `sshd_config` file `/etc/ssh/sshd.config` to remove root login permit, password authentification 

```bash
sudo vim /etc/ssh/sshd.conf
```

- Edit line 32 like: `PermitRootLogin no`
- Edit line 36 like: `PubkeyAuthentication no`
- Edit line 56 like `PasswordAuthentication no`
> Don't forget to delete de **#** at the beginning of each line

4. We need to restart the SSH daemon service
```bash
sudo service sshd restart
```
## 8. Setup Firewall with UFW. <a id="ufw"></a>

1. Make sure ufw is enable: if it disable make sure to turn ON.
```bash
sudo ufw status
```
 if not we can start the service with
 
 ```bash
 sudo ufw enable
 sudo ufw default reject incoming
 sudo ufw default allow outgoing
 sudo ufw status verbose : to see all the rules
 ```
 
2. Setup firewall rules
 ```bash
- SSH :		`sudo ufw limit 50683/tcp` (port number: 50683)
- HTTP :	`sudo ufw allow 80/tcp`
- HTTPS :	`sudo ufw allow 443`
 ```

### Sources:
	https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server
	https://www.cyberciti.biz/faq/howto-limiting-ssh-connections-with-ufw-on-ubuntu-debian/

⚡️ **Testing**

	sudo ufw status verbose : see the all firewal rules

## 9. Setup DOS protection with fail2ban. <a id="fail2ban"></a>

1. Check the current status

```
sudo service fail2ban status &&
sudo cat /etc/fail2ban/jail.local
```
2. Go to sudo vim /etc/fail2ban/jail.local and add following configurtion (add inside jail.loacl file)

```
[sshd]
enabled = true
port    = 50683
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 3
bantime = 600

#Add after HTTP servers:
[http-get-dos]
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/apache2/access.log
maxretry = 300
findtime = 300
bantime = 600
action = iptables[name=HTTP, port=http, protocol=tcp]
```
3. Add regex rules to http-get-dos by creating following file (Add http-get-dos filter)

```
sudo vim /etc/fail2ban/filter.d/http-get-dos.conf
```
4. Add the following configuration in http-get-dos.conf

```console
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*
ignoreregex =
```
5. At last, we need to reload firewall & fail2ban to make the change working
```bash
sudo ufw reload
sudo service fail2ban restart
```
6. sudo apt install apache2 -y

### 💡 ***NOTE***

	Regular expressions are used to detect break-in attempts, password failures, etc. 
	Regular expressions are looked to see if they match the lines of the logfile.
	You can use the predefined entity <HOST> in your regexes.
	<HOST> is an alias for (?:::f{4,6}:)?(?P<host>\S+), 
	which matches either a hostname or an IPv4 address (possibly embedded in an IPv6 address)

	The default Fail2Ban configuration file is located at /etc/fail2ban/jail.conf. The configuration work should not be done in that file,
	since it can be modified by package upgrades, but rather copy it so that we can make our changes safely.

⚡️ **Testing DOS attck**

	1. We can test if the new conf works with SlowLoris (an HTTP DDOS attack script)
	2. install git: sudo apt-get install git
	3. install SlowLoris: git clone https://github.com/gkbrk/slowloris.git slowloris
	4. go to: user/slowlaries directory
	5. python slowloris.py 10.11.199.12 (in the MAC TERMINAL)
	6. Check fail2ban.log that ip is banned from:  sudo tail -F /var/log/fail2ban.log
	7. or iptables --list | head ::::to check if its baned or not
	8. 0r sudo fail2ban-client status sshd :::: to check ssh banned actions
	9. fail2ban-client set YOURJAILNAMEHERE unbanip IPADDRESSHERE :To unban yourself

## 10. Setting up Protection against port scans. <a id="scanSecure"></a>

1. First we need to install the nmap tool with
	```
	sudo apt-get install nmap
	```
2. Then, we need to reconfigure `/etc/default/portsentry`. After it will look like below:

```
TCP_MODE="atcp"
UDP_MODE="audp"
```
3. After, edit the file `/etc/portsentry/portsentry.conf`. After it will look like below:

```
BLOCK_UDP="1"
BLOCK_TCP="1"
```
1. remove comment from the below's rule, like below:
```
	KILL_ROUTE="/sbin/iptables -I INPUT -s $TARGET$ -j DROP"
```
5. Add Comment on below's rule,
```
   #KILL_ROUTE="/sbin/route add -host $TARGET$ reject"
```
6. Add comment the following command:
```
 	#KILL_HOSTS_DENY="ALL: $TARGET$ : DENY
```
7. Finnaly, restart portsentry to make changes effective

```
sudo service portsentry restart
sudo service portsentry status
```

### 💡 ***NOTE***

	Nmap is a free and open source netwokr discovery and security utility. It works by ssending data packets on a specific target and by interpreting the incoming packets to determine what ports are open or closed.
	In standard mode portsentry runs in the background and reports any violations, in Stealth modes, PortSentry will use a raw socket to monitor all incoming packets, and if a monitored port is probed, it will block the host.  The most sensitive modes are those used by Advanced Stealth scan detection. You can explicitly ask PortSentry to ignore certain ports (which can be key when running a particularly reactionary configuration) to protect legitimate traffic. By default, PortSentry pays most attention to the first 1024 ports (otherwise known as privileged ports)because that’s where non-ephemeral connections usually originate from daemons.

⚡️ **Testing**

	1. To simulate the portscan, use nmap:
	2. In the host machine:
		a. Download nmap: brew install nmap
		b. Launch the scan: nmap 10.11.199.12. Nothing should happen.
	3. In the the VM, iptables --list | head should show your IP address is banned.
	4. iptables -D INPUT 1
	6. service restart portsentry
	7. check open ports and listened ports with :lsof -i -P

## 11. Stop the services we don’t need <a id="stopServices"></a>

1. To check all active processes: `systemctl list-units --type service --all`

```Service we need to disable
sudo systemctl disable console-setup.service
sudo systemctl disable keyboard-setup.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable syslog.service
```

⚡️ **Testing the services we don't need**

- [x] `sudo systemctl list-unit-files --type service | grep enabled`
- [x] Use `service --status-all` to list services. A '+' signifies the service is running, a '-' that it is stopped. For another list of services with their status and information about what they do, use `systemctl list-units | grep service`
- [x] The evaluation also requires that docker, vagrant, traefik, etc. are not used. You can check that they aren't with the command `apt search <docker/vagrant/...> | grep <docker/vagrant/...>`: if it was installed, the flag '[installed]' should appear next to the name of the package.

-----------
## 12. Script to update all the packages <a id="updateApt"></a>

1. Create `update_script.sh` file with `sudo vim /root/scripts/update_script.sh` & insert the following command inside the file

```bash
#!/bin/bash
echo "sudo apt-get update -y >> /var/log/update_script.log" >> ~/update.sh
echo "sudo apt-get upgrade -y >> /var/log/update_script.log" >> ~/update.sh
```
2. Change the file permission
```
sudo chmod 755 /root/scripts/update_script.sh
```
3. Make root be the owner for automated execution:
```
sudo chown root /root/scripts/update_script.sh
```
4. To automate execution, we must edit the crontab file & Add the task to cron (for scheduling)
```bash
sudo crontab -e
```
5.  Write the file following lines in crontab file

```bash
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

@reboot sudo ~/update.sh (for running it at boot)
0 4 * * 7 sudo ~/update.sh (for running it once a week, e.g. Sunday, at 4am)
```
-------
### 💡 ***NOTE***
	Don't forget to make your ~/mail.txt file !

			* * * * * command to be executed
			- - - - -
			| | | | |
			| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
			| | | ------- Month (1 - 12)
			| | --------- Day of month (1 - 31)
			| ----------- Hour (0 - 23)
			------------- Minute (0 - 59)

-------

⚡️ **Testing the scrips**

- [x] sudo cat /usr/local/sbin/update.sh
- [x] sudo cat /usr/local/sbin/change2crontab.sh
- [x] The **/var/log/update_script.log** should have a log of the boot at the begining of the evaluation. You can also execute the script and check that a log was added at the end of the file.
- [x] For the crontab checker :
    * Execute the script
        + If you kept the alias and are logged in as <username>, `mail` should tell you `No mail for <username>
        + If you kept the alias and are logged in as someone else, **/var/mail/<username>** should be empty
        + If you deleted the alias, **/var/mail/mail** should be empty
    * Edit **/etc/crontab** and execute the script. Now the same method as before should tell you that there is mail.

-------
## 13 Making a script to warn of all crontab edits