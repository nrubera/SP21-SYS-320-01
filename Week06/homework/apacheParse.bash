#!/bin/bash

# Storyline: Script that will Parse Apache Logs and add the bad IPs into a file


# Read in file

#Arguments using the position, they start at $1
APACHE_LOG="$1"

# Check if file exists
if [[ ! -f ${APACHE_LOG} ]]
then
	echo "Please specify the path to the log file."
	exit 1
fi

# Looking for web scanners
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep  -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t " | \
cut -f 1 -d - |sort -u |tee badip.txt

bash firewallrules.bash -p
bash firewallrules.bash -i
