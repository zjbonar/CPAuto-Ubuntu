#!/bin/bash
clear
echo "Answer all forensics questions before proceeding"
echo "Are you 100% ready to proceed? (y/n)"
read var
if [ $var = y ]
	then clear
	else exit
fi 

echo "Remember to run as root"
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
echo "Script completed at $(date +%T)"
echo ""
echo "REMEMBER TO MANUALLY EDIT CONFIG FILES!!!

/etc/lightdm/lightdm.conf  <== allow_guest=false
/etc/ssh/ssh_config <== PermitRootLogin no
/etc/sysctl.conf <== net.ipv4.tcp_syncookies=1"
echo ""
echo ""
