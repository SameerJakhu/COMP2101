#!/bin/bash

# Check if the user has root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privileges."
    exit 1
fi

# Function to check command success and print error message if it fails
check_command() {
    if [ $? -ne 0 ]; then
        echo "An error occurred while running the command: $1"
        exit 1
    fi
}

# System Description
echo "System Description"
echo "------------------"

manufacturer=$(dmidecode -s system-manufacturer)
check_command "dmidecode"
description=$(dmidecode -s system-product-name)
check_command "dmidecode"
serial_number=$(dmidecode -s system-serial-number)
check_command "dmidecode"

echo "Manufacturer: $manufacturer"
echo "Description: $description"
echo "Serial Number: $serial_number"
echo

# CPU Information
echo "CPU Information"
echo "---------------"

cpu_manufacturer=$(lshw -class processor | awk '/product/ {print $2}')
check_command "lshw"
cpu_model=$(lshw -class processor | awk '/product/ {print $3}')
check_command "lshw"
cpu_architecture=$(lshw -class processor | awk '/width/ {print $2}')
check_command "lshw"
cpu_core_count=$(lshw -class processor | awk '/core/ {print $4}' | head -n 1)
check_command "lshw"
cpu_max_speed=$(lshw -class processor | awk '/capacity/ {print $2}' | head -n 1)
check_command "lshw"
cache_sizes=$(lshw -class processor | awk '/size/ {print $2}' | head -n 3)
check_command "lshw"

echo "Manufacturer: $cpu_manufacturer"
echo "Model: $cpu_model"
echo "Architecture: $cpu_architecture"
echo "Core Count: $cpu_core_count"
echo "Maximum Speed: $cpu_max_speed"
echo "Cache Sizes:"
echo "$cache_sizes"
echo

# Operating System Information
echo "Operating System Information"
echo "---------------------------"

linux_distro=$(lsb_release -ds)
check_command "lsb_release"
distro_version=$(lsb_release -rs)
check_command "lsb_release"

echo "Linux Distro: $linux_distro"
echo "Distro Version: $distro_version"


