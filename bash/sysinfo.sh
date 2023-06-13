#!/bin/bash

# Check if the user has root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privileges."
    exit 1
fi

# System Description
echo "System Description"
echo "------------------"

manufacturer=$(dmidecode -s system-manufacturer 2>/dev/null)
if [[ -z $manufacturer ]]; then
    echo "Computer manufacturer: Data unavailable"
else
    echo "Computer manufacturer: $manufacturer"
fi

description=$(dmidecode -s system-product-name 2>/dev/null)
if [[ -z $description ]]; then
    echo "Computer description or model: Data unavailable"
else
    echo "Computer description or model: $description"
fi

serial_number=$(dmidecode -s system-serial-number 2>/dev/null)
if [[ -z $serial_number ]]; then
    echo "Computer serial number: Data unavailable"
else
    echo "Computer serial number: $serial_number"
fi

echo

# CPU Information
echo "CPU Information"
echo "---------------"

cpu_manufacturer=$(lshw -class processor | awk '/product/ {print $2}' 2>/dev/null)
if [[ -z $cpu_manufacturer ]]; then
    echo "CPU manufacturer: Data unavailable"
else
    echo "CPU manufacturer: $cpu_manufacturer"
fi

cpu_model=$(lshw -class processor | awk '/product/ {print $3}' 2>/dev/null)
if [[ -z $cpu_model ]]; then
    echo "CPU model: Data unavailable"
else
    echo "CPU model: $cpu_model"
fi

cpu_architecture=$(lshw -class processor | awk '/width/ {print $2}' 2>/dev/null)
if [[ -z $cpu_architecture ]]; then
    echo "CPU architecture: Data unavailable"
else
    echo "CPU architecture: $cpu_architecture"
fi

cpu_core_count=$(lshw -class processor | awk '/core/ {print $4}' | head -n 1 2>/dev/null)
if [[ -z $cpu_core_count ]]; then
    echo "CPU core count: Data unavailable"
else
    echo "CPU core count: $cpu_core_count"
fi

cpu_max_speed=$(lshw -class processor | awk '/capacity/ {print $2}' | head -n 1 2>/dev/null)
if [[ -z $cpu_max_speed ]]; then
    echo "CPU maximum speed: Data unavailable"
else
    echo "CPU maximum speed: $cpu_max_speed"
fi

cache_sizes=$(lshw -class processor | awk '/size/ {print $2}' | head -n 3 2>/dev/null)
if [[ -z $cache_sizes ]]; then
    echo "Cache sizes (L1, L2, L3): Data unavailable"
else
    echo "Cache sizes (L1, L2, L3):"
    echo "$cache_sizes"
fi

echo

# Operating System Information
echo "Operating System Information"
echo "---------------------------"

linux_distro=$(lsb_release -ds 2>/dev/null)
if [[ -z $linux_distro ]]; then
    echo "Linux distro: Data unavailable"
else
    echo "Linux distro: $linux_distro"
fi

distro_version=$(lsb_release -rs 2>/dev/null)
if [[ -z $distro_version ]]; then
    echo "Distro version: Data unavailable"
else
    echo "Distro version: $dist
