#!/bin/bash

# DEBUG
#set -x

# VARIABLES

# CONDITION ARGUMENTS

if [[ $# -ne 1 ]];
then
        echo "Error invalid number of arguments."
        echo "Example ./ping_ip.sh <path_to_file_with_ip>"
        exit 1
fi

if [[ -n "$1"  ]];
then
        echo "Agrument $IPLIST found."
else
        echo "No parameters found."
fi

IPLIST=$1
Flines=`cat $IPLIST | wc -l`

# DESIGN

GREENF='\e[32m'
NORMALF='\e[39m'
REDBACK='\e[41m'
BOLD='\e[1m'
NORMALB='\e[0m'
NORMALR='\e[49m'

if [ -f $IPLIST ];
then
	echo -e "\nFound IP addresses in file: $Flines\n"
else
	echo "File does not exist"
	exit
fi

for ip in $(cat $IPLIST);
do
	ping -c 1 "$ip" > /dev/null
	if [ $? -eq 0  ];
	then
		echo -e "`date`\t PING HOST\t $ip\t ${GREENF}PASSED${NORMALF}"
	else
		echo -e "`date`\t PING HOST\t $ip\t ${REDBACK}${BOLD}${RED}FAILED${NORMALR}${NORMALB}"
	fi
done

