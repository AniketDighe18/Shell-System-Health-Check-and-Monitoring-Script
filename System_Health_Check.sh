#!/bin/bash
echo "========================================="
echo "        SYSTEM HEALTH REPORT"
echo "========================================="
echo "Date      : $(date)"
echo "Hostname  : $(hostname)"
echo "Uptime    : $(uptime -p)"
echo "========================================="

# CPU Usage
echo -e "\n[CPU USAGE]"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Load: "100 - $8"%"}'

# Memory Usage
echo -e "\n[MEMORY USAGE]"
free -m | awk 'NR==2{printf "Used: %sMB / Total: %sMB (%.2f%%)\n",$3,$2,$3*100/$2 }'

# Disk Usage
echo -e "\n[DISK USAGE]"
df -h --total | grep total | awk '{print "Used: "$3 " / Total: "$2 " ("$5 " used)"}'

# Load Average
echo -e "\n[LOAD AVERAGE]"
uptime | awk -F'load average:' '{print $2}'

# Logged-in Users
echo -e "\n[LOGGED IN USERS]"
who

# Last Reboot
echo -e "\n[LAST REBOOT]"
who -b

# Top 5 Processes by CPU
echo -e "\n[TOP 5 PROCESSES BY CPU]"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 Processes by Memory
echo -e "\n[TOP 5 PROCESSES BY MEMORY]"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Network Info (IP Addresses)
echo -e "\n[NETWORK INFO]"


ip addr show | grep "inet " | awk '{print "IP Address: "$2" (Interface: "$NF")"}'

# Open Ports
echo -e "\n[OPEN PORTS]"
ss -tuln | grep LISTEN

# Service Status
echo -e "\n[SERVICE STATUS]"
SERVICES=("sshd" "firewalld" "crond" "network")
for service in "${SERVICES[@]}"; do
    systemctl is-active --quiet $service
    if [ $? -eq 0 ]; then
        echo "$service : running"
    else
        echo "$service : not running"
    fi
done

echo -e "\n========================================="
echo "       Health Check Completed!"
echo "========================================="

