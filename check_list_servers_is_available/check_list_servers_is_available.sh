#!/bin/bash

#set +x

if [[ $# < 1 ]] ; then
	echo "Error invalid number of arguments"
	echo "Example ./check_list_servers_is_available.sh <path_to_file_list_servers>"
	exit 1
fi

if [ $1 = "help" ]; then
	echo "The scripts check if server is available from dig and ip"
	echo "Usage: ./check_list_servers_is_available.sh <path_to_file_list_servers>"
	exit 1
fi

if [  -f "$FILE" ]; then
    rm ~/available_servers
fi

for i in `cat $1`; do
	IP_ADDR=$(if name=`dig +short $i`; then echo $name; else echo ''; fi )  # empty if not available
	if [ -n "$IP_ADDR" ]; then	# if available
		echo $i >>  ~/available_servers
	fi
done
