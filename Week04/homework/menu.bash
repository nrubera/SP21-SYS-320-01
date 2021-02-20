#!/bin/bash

# Storyline: Menu for admin, VPN, and security functions

function invalid_opt() {

	echo ""
	echo "Invalid Option"
	echo""
	sleep 2
}

function menu() {

	# clears the screen
	clear

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Block Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in 

		1) admin_menu
		;;

		2) security_menu
		;;


		3) block_menu
		;;

		4) exit 0
		;;


		*) invalid_opt

			# Call the main menu
			menu
		;;

	
	esac
	menu
}

function admin_menu() {
	
	clear
	echo "[L]ist Running Processes"
	echo "[N]etwork Sockets"
	echo "[V]PN Menu"
	echo "[4] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in

		L|l) ps -ef |less
		;;
		N|n) netstat -an --inet |less
		;;
		V|v) vpn_menu
		;;
		4) exit 0
		;;
		*) invalid_opt
			
			#Call the admin menu
			admin_menu
		;;
	esac
	admin_menu

}

function vpn_menu() {

	clear	
	echo "[A]dd a user"
	echo "[D]elete a user"
	echo "[B]ack to admin menu"
	echo "[M]ain menu"
	echo "[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in

		A|a) bash peer.bash
			tail -6 wg0.conf |less
		;;
		D|d) read -p "Please enter the user you wish to delete: " u_name
			bash manage-users.bash -d -u ${u_name}
			echo "Deleting the user..."
			echo "User deleted!"
		;;
		B|b) admin_menu
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*) invalid_opt
			#Call the vpn menu
			vpn_menu
		;;
	esac
	vpn_menu
}

function security_menu() {
	
	clear
	echo "[L]ist open network sockets"
	echo "[C]heck if any users has UID of 0"
	echo "[U]sers last logged in"
	echo "[S]ee logged in users"
	echo "[M]ain Menu"
	echo "[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in

		L|l) netstat -an --inet |less
		;;
		C|c) id
		;;
		U|u) last -10
		;;
		S|s) w
		;;
		M|m) menu
		;;
		E|e) exit 0
		;;
		*) invalid_opt
			security menu
		;;

	esac
	security_menu
}

function block_menu() {
	clear
	echo "[C]isco blocklist gen"
	echo "[D]omain blocklist gen"
	echo "[N]etscreen blocklist gen"
	echo "[W]indows blocklist gen"
	read -p "Please select an option: " choice

	case "$choice" in

		C|c) bash parse-threat.bash -c
		;;
 	 	D|d) bash parse-threat.bash -g
		;;
	 	N|n) bash parse-threat.bash -n
		;;
		W|w) bash parse-threat.bash -w
		;;
		*) invalid_opt
			block_menu
		;;
	esac
}

# Call the main function
menu
