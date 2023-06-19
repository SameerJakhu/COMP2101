#!/bin/bash

# Function to display a title
function title {
    echo "=== $1 ==="
    echo
}

# Function to display labeled data
function labeled_data {
    echo "$1: $2"
}

# Function for CPU report
function cpureport {
    title "CPU Report"
    labeled_data "Manufacturer and Model" "$(lscpu | awk -F': +' '/^Model name/ {print $2}')"
    labeled_data "Architecture" "$(lscpu | awk -F': +' '/^Architecture/ {print $2}')"
    labeled_data "Core Count" "$(lscpu | awk -F': +' '/^CPU\(s\)/ {print $2}')"
    labeled_data "Maximum Speed" "$(lscpu | awk -F': +' '/^CPU max MHz/ {print $2}') MHz"
    labeled_data "L1 Cache" "$(lscpu | awk -F': +' '/^L1d cache/ {print $2}')"
    labeled_data "L2 Cache" "$(lscpu | awk -F': +' '/^L2 cache/ {print $2}')"
    labeled_data "L3 Cache" "$(lscpu | awk -F': +' '/^L3 cache/ {print $2}')"
}

# Function for computer report
function computerreport {
    title "Computer Report"
    labeled_data "Manufacturer" "$(sudo dmidecode -s system-manufacturer)"
    labeled_data "Description/Model" "$(sudo dmidecode -s system-product-name)"
    labeled_data "Serial Number" "$(sudo dmidecode -s system-serial-number)"
}

# Function for OS report
function osreport {
    title "OS Report"
    labeled_data "Linux Distro" "$(lsb_release -d | awk -F':\t' '{print $2}')"
    labeled_data "Distro Version" "$(lsb_release -r | awk -F':\t' '{print $2}')"
}

# Function for RAM report
function ramreport {
    title "RAM Report"
    sudo dmidecode -t memory | awk -v RS= '/Size: [0-9]+/ && /Locator: [A-Za-z0-9]+/ && /Type: [A-Za-z0-9]+/ && /Speed: [0-9]+/ {print "Component:", $0}'
    labeled_data "Total Size" "$(free -h | awk '/^Mem:/ {print $2}')"
}

# Function for video report
function videoreport {
    title "Video Report"
    labeled_data "Manufacturer" "$(lspci | awk -F': ' '/VGA compatible controller/ {print $3}')"
    labeled_data "Description/Model" "$(lspci | awk -F': ' '/VGA compatible controller/ {print $4}')"
}

# Function for disk report
function diskreport {
    title "Disk Report"
    lsblk -io NAME,SIZE,MOUNTPOINT,FSTYPE | awk -F' ' '/^NAME/ {print "Drive Manufacturer\tDrive Model\tDrive Size\tPartition Number\tMount Point\tFilesystem Size\tFilesystem Free Space"} \
    !/^NAME/ {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}'
}

# Function for network report
function networkreport {
    title "Network Report"
    ip -o -4 addr show | awk -F' ' '{print $2"\t"$4"\t"$5}'
}
