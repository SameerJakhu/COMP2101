#!/bin/bash
#
# This script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# The LAN info in this script uses a hardcoded interface name of "eno1"
#    - Change eno1 to whatever interface you have and want to gather info about in order to test the script

################
# Data Gathering
################

# Task 1: Accept options on the command line for verbose mode and an interface name
# - Use the while loop and case command to process the command line options
# - If the user includes the option -v on the command line, set the variable $verbose to contain the string "yes"
# - If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface

# Default values
verbose=""
interface=""

# Process command line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v)
      verbose="yes"
      shift
      ;;
    *)
      # If the option doesn't start with "-", consider it as an interface name
      if [[ $1 == -* ]]; then
        echo "Unknown option: $1" >&2
        exit 1
      fi
      if [[ -n $interface ]]; then
        echo "Only one interface name can be specified" >&2
        exit 1
      fi
      interface="$1"
      shift
      ;;
  esac
done

#####
# Once per host report
#####
[[ $verbose == "yes" ]] && echo "Gathering host information"

# Use the hostname command to get the system name and main IP address
my_hostname="$(hostname) / $(hostname -I)"

[[ $verbose == "yes" ]] && echo "Identifying default route"

# Find the default route and router name
default_router_address=$(ip r s default | awk '{print $3}')
default_router_name=$(getent hosts $default_router_address | awk '{print $2}')

[[ $verbose == "yes" ]] && echo "Checking for external IP address and hostname"

# Find the external IP address and name
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

# Task 2: Dynamically identify the list of interface names and generate the report for every interface except loopback

interfaces=$(ip -o link show | awk -F': ' '{print $2}')

for iface in $interfaces; do
  if [[ $iface != "lo" ]]; then
    [[ $interface != "" && $iface != $interface ]] && continue

    # Per-interface report

    [[ $verbose == "yes" ]] && echo "Reporting on interface(s): $iface"

    [[ $verbose == "yes" ]] && echo "Getting IPV4 address and name for interface $iface"

    # Find an address and hostname for the interface
    ipv4_address=$(ip a s $iface | awk -F '[/ ]+' '/inet /{print $3}')
    ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

    [[ $verbose == "yes" ]] && echo "Getting IPV4 network block info and name for interface $iface"

    # Identify the network number and name for the interface
    network_address=$(ip route list dev $iface scope link | cut -d ' ' -f 1)
    network_number=$(cut -d / -f 1 <<<"$network_address")
    network_name=$(getent networks $network_number | awk '{print $1}')

    cat <<EOF

Interface $iface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
  fi
done
