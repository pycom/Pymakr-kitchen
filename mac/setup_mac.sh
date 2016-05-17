#!/usr/bin/env bash


request_macports () {
	port version &> /dev/null
	if [[ $? != 0 ]]; then
		echo "Please install MacPorts before continuing"
		exit 1
	fi
}

install_ports () {
	echo "WARNING: This will unistall all your MacPorts packages, and then install what is needed"
	read -p "Do you wish to continue? " -n 1 -r REPLY
	echo    # (optional) move to a new line
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
	    exit 0
	fi	
	
	sudo port -fp uninstall --follow-dependents installed
	sudo port install py-qscintilla py-setuptools py-serial
}

main () {
	request_macports
	install_ports
}

main

