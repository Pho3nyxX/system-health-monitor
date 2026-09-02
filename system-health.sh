#!/bin/bash

echo "========================================"
echo "       LINUX SYSTEM HEALTH MONITOR"
echo "========================================"

HOSTNAME=$(hostname)
OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f 2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)

echo
echo "Hostname: $HOSTNAME"
echo "OS: $OS"
echo "KERNEL: $KERNEL"
echo "UPTIME: $UPTIME"

echo
echo "----------------------------------------"
echo "          SYSTEM RESOURCES"              
echo "----------------------------------------"

MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')

echo "CPU Usage: $CPU_USAGE%"
echo "Memory Usage: $MEMORY_USAGE%"
echo "Disk Usage: $DISK_USAGE%"

echo
echo "----------------------------------------"
echo "               NETWORK"
echo "----------------------------------------"

IP_ADDRESS=$(hostname -I | awk '{print $1}')

if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    INTERNET="ONLINE"
else
    INTERNET="OFFLINE"
fi

echo "IP Address: $IP_ADDRESS"
echo "Internet:   $INTERNET"

echo
echo "----------------------------------------"
echo "            TOP PROCESSES"
echo "----------------------------------------"

ps -eo comm,%cpu --sort=-%cpu | head -n 6