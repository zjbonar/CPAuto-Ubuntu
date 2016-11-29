#!/bin/bash
clear
echo "Remember to run as root"
echo "Running CPAuto at $(date +%T)"
echo "Enabling Firewall..."
ufw enable
sleep 3s
echo "Script completed at $(date +%T)"
