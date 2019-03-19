#!/bin/bash
killall geth bootnode constellation-node

if [ "`jps | grep tessera`" != "" ]
then
  jps | grep tessera | cut -d " " -f1 | xargs kill
else
  echo "tessera: no process found"
fi

#check for connections open in TIME_WAIT status
DOWN=true
while $DOWN; do
	sleep 1
	DOWN=false
	i=`netstat -n | grep TIME_WAIT | grep -v 443| wc -l`
	if [ $i -gt 1 ]
	then
		echo "Waiting for TIME_WAIT connections to close"
		DOWN=true
	else
		echo "All connections closed"
	fi
done
