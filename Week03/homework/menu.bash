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
	echo "[3] Exit"
	read -p "Please enter a choice above: " choice

	case "$choice" in 

		1) admin_menu
		;;

		2) security_menu
		;;


		3) exit 0
		;;


		*) invalid_opt

			# Call the main menu
			menu
		;;

	
	esac
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
		D|d) read "Please enter the user you wish to delete: " u_name
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
}

# Call the main function
menu
