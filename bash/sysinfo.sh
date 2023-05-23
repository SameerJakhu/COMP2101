
#!/bin/bash

# Displaying the fully qualified domain name 
echo "FQDN:"
hostname --fqdn

# Displaying the os name and version
echo "Host Information:"
hostnamectl

# Displaying the IP address of the host
echo "IP Addresses:"
hostname -I

# Displaying the space in the root file system
echo "Root Filesystem Status:"
df -h /
