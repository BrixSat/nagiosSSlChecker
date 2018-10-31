#!/bin/bash

#if [ -z $1 ]
#then
#	echo "Please use a domain as argument."
#	exit 1
#fi

#openssl s_client -connect ${1}:443 -servername ${1}


######################################
#
# SSL-Check Certificate Checker
# Author: Trey Brister 2014
#
# Converted to nagios by César Araújo
# 
# URL: http://www.shellhacks.com/en/HowTo-Check-SSL-Certificate-Expiration-Date-from-the-Linux-Shell
# URL: http://stackoverflow.com/questions/5155923/sending-a-mail-from-a-linux-shell-script
# URL: http://stackoverflow.com/questions/4946785/how-to-find-the-difference-in-days-between-two-dates
# URL: http://www.thegeekstuff.com/2011/07/bash-for-loop-examples/
#
######################################

## If no argument is supplied then exit with a helpful message
[[ $@ ]] || { echo "To check the SSL certificate, please enter your domain name"; exit 1; }

## Variables to start off with

# Amount of time before expiration to receive alerts every day (Default: 7)
# Will still receive 14 and 30 day notices in addition to ${ALERTDAYS}
# Usage: ${ALERTDAYS}
export ALERTDAYS=30

export CRITICALDAYS=7

# Get the domain name from the SSL certificate
# Usage: ${DOMAIN}
export DOMAIN=$(echo | openssl s_client -connect ${1}:443 -servername ${1} 2>/dev/null | openssl x509 -noout -subject|cut -d= -f4|cut -d/ -f1)

# Strip leading space.
DOMAIN="${DOMAIN## }"
# Strip trailing space.
DOMAIN="${DOMAIN%% }"

# SSL certificate expiration date formatted like YYYY-MM-DD
# Usage: ${EXPIRATION}
export EXPIRATION=$(date -d "$(echo | openssl s_client -connect ${1}:443 -servername ${1} 2>/dev/null | openssl x509 -noout -dates|grep notAfter|cut -d= -f2)" +%Y-%m-%d)

# Get todays date formated like YYYY-MM-DD
# Usage: ${TODAY}
export TODAY=$(date +%Y-%m-%d)

# Use mysql to subtract the two dates
# I log into mysql with a test account that has no access to any databases
# Usage: $(DIFF)
DIFF () {
    echo $(( (`date -d $EXPIRATION +%s` - `date -d $TODAY +%s`) / 86400 ))
}

if [[ $(DIFF) -le ${ALERTDAYS} && $(DIFF) -gt ${CRITICALDAYS}  ]]
then
	echo "Warning - ${DOMAIN} SSL certificate will expire in $(DIFF) days."
	exit 1
else
	if [[ $(DIFF) -le ${CRITICALDAYS} && $(DIFF) -gt 0 ]]
	then
		echo "Critical - ${DOMAIN} SSL certificate will expire in $(DIFF) days."
		exit 2
	else
		if [[ $(DIFF) -le 0 ]]
		then
			if [[ $(DIFF) -eq 0 ]]
			then
				echo "Critical - ${DOMAIN} SSL certificate expired today."
				exit 2	 	
			else
				DIFFP=$(echo $(DIFF) | sed 's/-//g')
				echo "Critical - ${DOMAIN} SSL certificate expired ${DIFFP} days ago."
				exit 2
			fi
	 	else
	 		echo "The ${DOMAIN} SSL certificate will not expire for another $(DIFF) days. ";
    		exit 0
    	fi
	fi
fi

