#!/bin/bash
#
# install-salt-master-centos6.sh
#
# Prepared by: Joseph Yennaco
# Contact: Joe.Yennaco@pci-sm.com
# PCI Strategic Management, LLC
# 15 New England Executive Park #2106
# Burlington, MA 01803
#
# Date: 26 February 2014
#
# Purpose: This script installs Salt Master on CentOS6 using the EPEL repository and YUM.
#
# Prerequisites:
# 	-- Internet connectivity
#  	-- Run this script as root user
# 

# Get the current timestamp and append to logfile name
TIMESTAMP=$(date "+%Y-%m-%d-%H%M")
LOGFILE=/var/log/cons3rt-install-salt-master-centos6-${TIMESTAMP}.log

# Set log commands
logTag=salt-master
logInfo="logger -i -s -p local3.info -t ${logTag} [INFO] "
logWarn="logger -i -s -p local3.warning -t ${logTag} [WARNING] "
logErr="logger -i -s -p local3.err -t ${logTag} [ERROR] "

# Set a local variable for the location and filename of the bash profile
BASH_RC=/etc/bashrc

function install-salt-master-centos6() {
	
	$logInfo "Running the install-salt-master-centos6.sh install script @ $TIMESTAMP ..."
	
	# Source the bash profile to load JAVA_HOME
	$logInfo "Sourcing ${BASH_RC} ..."
	source ${BASH_RC}
	
	$logInfo "Printing the environment ..."
	printenv
	
	$logInfo "Enabling the EPEL repository ..."
	rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	
	$logInfo "Installing salt-master ..."
	yum -y --enablerepo=epel-testing install salt-master
	
	$logInfo "Enabling salt-master to start automatically upon boot ..."
	chkconfig salt-master on
	
	$logInfo "Configuring salt-master to auto-accept all keys from minions ..."
	sed -i "s/#auto_accept: False/auto_accept: True/" /etc/salt/master
	
	$logInfo "Start the salt-master service ..."
	service salt-master start
	
	$logInfo "Checking to see if salt is running ..."
	salt --version
	
	$logIngo "Note that the salt master is listening on ports 4505 and 4506 on all interfaces (0.0.0.0), and is auto-accepting all keys from minions."

	$logInfo "Completed running the install-salt-master-centos6.sh install script @ $TIMESTAMP!\n"
}

# Run the Installation function store output to the logfile
install-salt-master-centos6 2>&1 | tee ${LOGFILE}

exit 0
