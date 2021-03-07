
#!/bin/bash

# Storyline: Script to pipe in inputs from different script in order to make changes to firewall rules

while getopts 'pi' OPTION
do

	case "$OPTION" in

		P|p)
			for eachIP in $(cat badip.txt)
			do
				echo "netsh advfirewall firewall add rule name='BLOCKED IP ADDRESS - ${eachIP}' dir=in action=block remoteip=${eachIP}" | tee -a psFirewallRules.txt
			done
			exit 0

		;;


		I|i)

			for eachIP in $(cat badip.txt)
			do
				echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a iptableRules.txt
			done
			exit 0
		;;

	esac
done
