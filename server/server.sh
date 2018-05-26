#!/bin/bash

# if the backpipe doesn't exists, create it
if [ ! -e server/backpipe ];
then
	mkfifo server/backpipe
fi

while true;
do
	# listen while there is a request
	echo "server is listening"
	# intercept the request
	nc -lp $1 > server_in.txt

	# read from file, and split (by space) parts in array
	cmd=$(<server_in.txt)
	cmd_parts=( $cmd )

	# do something depending on the request
	if [[ ${cmd_parts[0]} == "list" ]];
	then
  		nc -l 1234 < server/backpipe | bash server/list.sh> server/backpipe
	elif [[ ${cmd_parts[0]} == "extract" ]];
	then
		nc -l 1234 < server/backpipe | bash server/extract.sh ${cmd_parts[1]} > server/backpipe
	elif [[ ${cmd_parts[0]} == "browse" ]];
	then
		nc -l 1234 < server/backpipe | bash server/browse.sh ${cmd_parts[1]} > server/backpipe
	elif [[ ${cmd_parts[0]} == "browsels" ]];
	then
		nc -l 1234 < server/backpipe | bash server/browse_ls.sh ${cmd_parts[1]} ${cmd_parts[2]} > server/backpipe
	elif [[ ${cmd_parts[0]} == "browsecat" ]];
	then
		nc -l 1234 < server/backpipe | bash server/browse_cat.sh ${cmd_parts[1]} ${cmd_parts[2]} > server/backpipe
	elif [[ ${cmd_parts[0]} == "browserm" ]];
	then
		nc -l 1234 < server/backpipe | bash server/browse_rm.sh ${cmd_parts[1]} ${cmd_parts[2]} ${cmd_parts[3]} > server/backpipe
	elif [[ ${cmd_parts[0]} == "browsermdir" ]];
	then
		nc -l 1234 < server/backpipe | bash server/browse_rmdir.sh ${cmd_parts[1]} ${cmd_parts[2]} > server/backpipe
	elif [[ ${cmd_parts[0]} == "direxists" ]];
	then
		nc -l 1234 < server/backpipe | bash server/dir_exists.sh ${cmd_parts[1]} ${cmd_parts[2]} > server/backpipe
	else
		echo "Unknow command. Try 'list', 'extract' or 'browse'"
	fi
done