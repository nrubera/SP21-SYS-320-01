#!/bin/bash

# Worked on this asignment with Nick L.
# Storyline: Script for local security checks

function check() {
	if [[ $2  != $3 ]]
	then
		echo -e  "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current value is: $3. Remediation: $4.\e[0m"
	else
		echo -e  "\e[1;32mThe $1 is compliant. Current value: $3.\e[0m"
	fi
}

#Check the password max day policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')
#Check the password max
check "Password Max Days" "365" "${pmax}" "Open /etc/login.defs and change the line \n PASS_MAX_DAYS [#] \n to \n PASS MAX_DAYS  365"

# Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
check "Password Min Days" "14" "${pmin}" "Open /etc/login.defs and change the following line from \n PASS_MIN_DAYS [#] \n to \n PASS_MIN_DAYS 14"

#Check the pass warn age
pwarn=i$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
check "Password Warn Age" "7" "${pwarn}"

#Check the SSH UsePam config
chkSSHPAM=$(egrep -i '^UsePAM' /etc/ssh/sshd_config | awk ' { print $2 }' )
check "SSH UsePam" "yes" "${chkSSHPAM}"

#Check permissions on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3} ')
do
	chDir=$(ls -ld /home/${eachDir} | awk '  { print $1 } ')
	check "Home directory ${eachDir}" "drwx------" "${chDir}" "To edit the policy, use the command chmod -xr [user] as root to change these permissions."
done


#Check ip forwarding
ipfor=$(egrep -i '^net.ipv4.ip_forward' /etc/sysctl.conf | awk ' { print $2 } ')
check "IP Forwarding" "0" "${chkIPforward}" "Edit /etc/sysctl.conf and set: \nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run: \n sysctl -w"

#Check ICMP redirects
icmp=$(egrep -i '^net.ipv4.conf.all.accept_redirects' /etc/sysctl.conf | awk ' { print $2 } ')
check "ICMP redirects" "0" "${icmp}"

#Check perms on crontab
crontab=$(stat /etc/crontab | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Crontab" "0/" "${crontab}"

#Check perms on cron.hourly
cronhourly=$(stat /etc/cron.hourly | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "CronHourly" "0/" "${cronhourly}"

#Check perms on cron.daily
crondaily=$(stat /etc/cron.daily | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "CronDaily" "0/" "${crondaily}"

#Check perms on cron.weekly
cronweekly=$(stat /etc/cron.weekly | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "CronWeekly" "0/" "${cronweekly}"

#Check perms on cron.monthly
cronmonthly=$(stat /etc/cron.monthly | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "CronMonthly" "0/" "${cronmonthly}"

#Check perms on passwd
passwd=$(stat /etc/passwd | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Password" "0/" "${passwd}"

#Check perms on shadow
shadow=$(stat /etc/shadow | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Shadow" "0/" "${shadow}"

#Check perms on group
group=$(stat /etc/group | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Group" "0/" "${group}"

#Check perms on gshadow
gshadow=$(stat /etc/gshadow | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "GShadow" "0/" "${gshadow}"

#Check perms on passwd-
passwddash=$(stat /etc/passwd- | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Password -" "0/" "${passwddash}"

#Check perms on shadow-
shadowdash=$(stat /etc/shadow- | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Shadow -" "0/" "${shadowdash}"

#Check perms on group=
groupdash=$(stat /etc/group-  | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "Group -" "0/" "${groupdash}"

#Check perms on gshadow-
gshadowdash=$(stat /etc/gshadow- | egrep -i '^Access: \(' | awk ' {  print $5 } ')
check "GShadow -" "0/" "${gshadowdash}"

#Check for + in passwd
legacypasswd=$(grep -i '^\+:' /etc/passwd)
check "Legacy Password" "" "${legacypasswd}"

#Check fpr + in shadow
legacyshadow=$(sudo grep -i '^\+:' /etc/shadow)
check "Legacy Shadow" "" "${legacyshadow}"

#Chek for + in group
legacygroup=$(grep -i '^\+:' /etc/group)
check "Legacy Group" "" "${legacygroup}"

#Check for UID 0
uid0=$(getent passwd | grep :0:)
check "UID 0" "root:x:0:0:root:/root:usr/bin/zsh" "${uid0}"








