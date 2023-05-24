#!/bin/bash
#
# this script gets some picture files for our personal web pages, which are kept in public_html
# the pictures are put into a subdirectory of public_html named pics
# it does some error checking
# it summarizes the public_html/pics directory when it is done
#
# It should not be run as root
if [ "$(whoami)" = "root" ]; then
echo "Not to be run as root"
exit 1
fi
# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
#   - use the same kind of testing that is already in the script to only download the tarfile if you don't already have it and
#     to make sure the download and extraction commands work
#     then delete the local copy of the tarfile if the extraction was successful

# make sure we have a clean pics directory to start with

if [ ! -f ~/public_html/pics.tgz ]; then
wget -q -O ~/public_html/pics.tgz https://zonzorp.net/pics.tgz
if [ $? -eq 0 ]; then
tar -xzf ~/public_html/pics.tgz -C ~/public_html/pics
if [ $? -eq 0 ]; then
rm ~/public_html/pics.tgz
else
echo "Failed to extract the tarfile"
exit 1
fi
else
echo "Failed to download the tarfile"
exit 1
fi
fi

rm -rf ~/public_html/pics
mkdir -p ~/public_html/pics || (echo "Failed to make a new pics directory" && exit 1)

# download a zipfile of pictures to our Pictures directory - assumes you are online
# unpack the downloaded zipfile if the download succeeded - assumes we have an unzip command on this system
# delete the local copy of the zipfile after a successful unpack of the zipfile
wget -q -O ~/public_html/pics/pics.zip http://zonzorp.net/pics.zip && unzip -d ~/public_html/pics -o -q ~/public_html/pics/pics.zip && rm ~/public_html/pics/pics.zip

# Task 1: Improve this script to also retrieve and install the files kept in the https://zonzorp.net/pics.tgz tarfile
#     test to make sure the download and extraction commands work
#     then delete the local copy of the tarfile if the extraction was successful

# Make a report on what we have in the Pictures directory
if [ -d ~/public_html/pics ]; then
file_count=$(find ~/public_html/pics -type f | wc -l)
disk_usage=$(du -sh ~/public_html/pics | awk '{print $1}')
cat <<EOF
Found $file_count files in the public_html/pics directory.
The public_html/pics directory uses $disk_usage of disk space.
EOF
else
echo "Failed to create the public_html/pics directory"
fi
