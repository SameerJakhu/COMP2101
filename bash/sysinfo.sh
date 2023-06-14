#!/bin/bash

# Check if the user has root privilege
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with root privileges."
  exit 1
fi

###############
# System Description
###############

echo "System Description"
echo "=================="

# Get computer manufacturer
manufacturer=$(dmidecode -s system-manufacturer)
if [[ -n $manufacturer ]]; then
  echo "Computer Manufacturer: $manufacturer"
else
  echo "Error: Unable to retrieve computer manufacturer."
fi

# Get computer description or model
model=$(dmidecode -s system-product-name)
if [[ -n $model ]]; then
  echo "Computer Model: $model"
else
  echo "Error: Unable to retrieve computer model."
fi

# Get computer serial number
serial=$(dmidecode -s system-serial-number)
if [[ -n $serial ]]; then
  echo "Serial Number: $serial"
else
  echo "Error: Unable to retrieve serial number."
fi

###############
# CPU Information
###############

echo
echo "CPU Information"
echo "==============="

# Get CPU information
cpu_info=$(lshw -class processor 2>/dev/null)
if [[ -n $cpu_info ]]; then
  cpu_count=$(grep -c "product" <<< "$cpu_info")
  if [[ $cpu_count -gt 0 ]]; then
    i=0
    while IFS= read -r line; do
      if [[ $line == *"product:"* ]]; then
        i=$((i+1))
        cpu_model=$(awk -F ': ' '{print $2}' <<< "$line")
        echo "CPU $i: $cpu_model"
      elif [[ $line == *"configuration: cores="* ]]; then
        cpu_cores=$(awk -F 'cores=' '{print $2}' <<< "$line")
        echo "    Cores: $cpu_cores"
      elif [[ $line == *"clock"* ]]; then
        cpu_speed=$(awk -F 'clock: ' '{print $2}' <<< "$line")
        echo "    Maximum Speed: $cpu_speed"
      elif [[ $line == *"size"* ]]; then
        cache_size=$(awk -F 'size: ' '{print $2}' <<< "$line")
        cache_unit=$(awk -F 'size: ' '{print $2}' <<< "$line")
        echo "    Cache Size: $cache_size $cache_unit"
      fi
    done <<< "$cpu_info"
  else
    echo "Error: Unable to retrieve CPU information."
  fi
else
  echo "Error: Unable to retrieve CPU information."
fi

###############
# Operating System Information
###############

echo
echo "Operating System Information"
echo "============================"

# Get Linux distro
linux_distro=$(lsb_release -ds)
if [[ -n $linux_distro ]]; then
  echo "Linux Distro: $linux_distro"
else
  echo "Error: Unable to retrieve Linux distro information."
fi

# Get distro version
distro_version=$(lsb_release -rs)
if [[ -n $distro_version ]]; then
  echo "Distro Version: $distro_version"
else
  echo "Error: Unable to retrieve distro version information."
fi

###############
# RAM Information
###############

echo
echo "RAM Information"
echo "==============="

# Get installed memory components
memory_info=$(lshw -class memory 2>/dev/null)
if [[ -n $memory_info ]]; then
  echo "Component Manufacturer  | Component Model   | Component Size  | Component Speed  | Component Location"
  echo "-----------------------|-------------------|-----------------|------------------|------------------"
  while IFS= read -r line; do
    if [[ $line == *"description: "* ]]; then
      manufacturer=$(awk -F 'description: ' '{print $2}' <<< "$line")
    elif [[ $line == *"product: "* ]]; then
      model=$(awk -F 'product: ' '{print $2}' <<< "$line")
    elif [[ $line == *"size: "* ]]; then
      size=$(awk -F 'size: ' '{print $2}' <<< "$line")
      size_unit=$(awk -F 'size: ' '{print $2}' <<< "$line")
    elif [[ $line == *"clock: "* ]]; then
      speed=$(awk -F 'clock: ' '{print $2}' <<< "$line")
    elif [[ $line == *"location: "* ]]; then
      location=$(awk -F 'location: ' '{print $2}' <<< "$line")
      echo "$manufacturer           | $model           | $size $size_unit | $speed           | $location"
    fi
  done <<< "$memory_info"
else
  echo "Error: Unable to retrieve RAM information."
fi

# Get total size of installed RAM
total_ram=$(grep -m 1 "size: " <<< "$memory_info" | awk -F 'size: ' '{print $2}')
total_ram_unit=$(grep -m 1 "size: " <<< "$memory_info" | awk -F 'size: ' '{print $2}')
if [[ -n $total_ram ]]; then
  echo
  echo "Total Installed RAM: $total_ram $total_ram_unit"
else
  echo "Error: Unable to retrieve total installed RAM."
fi

###############
# Disk Storage Information
###############

echo
echo "Disk Storage Information"
echo "========================"

# Get installed disk drives
disk_info=$(lshw -class disk 2>/dev/null)
if [[ -n $disk_info ]]; then
  echo "Drive Manufacturer   | Drive Model        | Drive Size  | Partition | Mount Point | Filesystem Size | Filesystem Free Space"
  echo "---------------------|--------------------|-------------|-----------|-------------|-----------------|---------------------"
  while IFS= read -r line; do
    if [[ $line == *"vendor: "* ]]; then
      manufacturer=$(awk -F 'vendor: ' '{print $2}' <<< "$line")
    elif [[ $line == *"product: "* ]]; then
      model=$(awk -F 'product: ' '{print $2}' <<< "$line")
    elif [[ $line == *"size: "* ]]; then
      size=$(awk -F 'size: ' '{print $2}' <<< "$line")
      size_unit=$(awk -F 'size: ' '{print $2}' <<< "$line")
    elif [[ $line == *"logical name: /dev/"* ]]; then
      partition=$(awk -F 'logical name: /dev/' '{print $2}' <<< "$line")
      mount_point=$(df -h | awk -v p="/dev/$partition" '$1==p{print $6}')
      fs_size=$(df -h | awk -v p="/dev/$partition" '$1==p{print $2}')
      fs_free=$(df -h | awk -v p="/dev/$partition" '$1==p{print $4}')
      echo "$manufacturer      | $model        | $size $size_unit | $partition  | $mount_point | $fs_size         | $
