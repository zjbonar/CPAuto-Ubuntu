#!/bin/bash
clear
echo "Remember to run as root"
echo "Answer all forensics questions before proceeding"
echo "Are you 100% ready to proceed? (y/n)"
read begin
if [ $begin = y ]
	then clear
	else echo "Script completed at $(date +%T)"
	exit	
fi 
echo "Running CPAuto at $(date +%T)"
echo "Enabling Firewall..."
ufw enable
echo "Blocking Telnet and other malicious ports..."
ufw deny 23
ufw deny 2049
ufw deny 111
ufw deny 515

iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 23 -j DROP         #Block Telnet
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 2049 -j DROP       #Block NFS
iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 2049 -j DROP       #Block NFS
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 6000:6009 -j DROP  #Block X-Windows
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 7100 -j DROP       #Block X-Windows font server
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 515 -j DROP        #Block printer port
iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 515 -j DROP        #Block printer port
iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 111 -j DROP        #Block Sun rpc/NFS
iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 111 -j DROP        #Block Sun rpc/NFS
iptables -A INPUT -p all -s localhost -i eth0 -j DROP #Deny outside packets from internet which claim to be from your loopback interface.
echo ""
echo "Would you like to delete media files? This process may take a while. (y/n)"
read media
if [ $media = y ]
	then 	find / -name '*.mp3' -type f -delete
		find / -name '*.mov' -type f -delete
		find / -name '*.mp4' -type f -delete
		find / -name '*.avi' -type f -delete
		find / -name '*.mpg' -type f -delete
		find / -name '*.mpeg' -type f -delete
		find / -name '*.flac' -type f -delete
		find / -name '*.m4a' -type f -delete
		find / -name '*.flv' -type f -delete
		find / -name '*.ogg' -type f -delete
		find /home -name '*.gif' -type f -delete
		find /home -name '*.png' -type f -delete
		find /home -name '*.jpg' -type f -delete
		find /home -name '*.jpeg' -type f -delete
fi 

echo ""
echo "Would you like to update? This process may take a while. (y/n)"
read up
if [ $up = y ]
	then 	apt-get update
		apt-get upgrade
fi
echo ""
echo "REMEMBER TO MANUALLY EDIT CONFIG FILES!!!

/etc/lightdm/lightdm.conf  <== allow_guest=false
/etc/ssh/ssh_config <== PermitRootLogin no
/etc/sysctl.conf <== net.ipv4.tcp_syncookies=1"
echo ""
echo ""
echo "Script completed at $(date +%T)"
