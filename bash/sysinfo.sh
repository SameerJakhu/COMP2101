#!/bin/bash

# Storing the Variables
hostname=$(hostname)
fqdn=$(hostname -f)
os_name=$(lsb_release -ds)
ip_add=$(ip route get 8.8.8.8 | awk 'NR==1{print $7}')
disk_free=$(df -h / | awk 'NR==2{print $4}')

# Output Template

cat <<EOF

Report for $hostname
====================
FQDN: $fqdn
Operating System name and version: $os_name
IP Address: $ip_add
Root Filesystem Free Space: $disk_free
====================

EOF

