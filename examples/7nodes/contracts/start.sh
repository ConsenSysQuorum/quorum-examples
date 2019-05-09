#!/usr/bin/env bash
set -u
set -e

mode=$1

cd ..

./stop.sh
echo $PWD

# run raft-init.sh
if [ "$mode"  ==  "IBFT" ]
then
    echo "######### starting in IBFT mode to deploy the contracts ######"
    ./istanbul-init.sh
    ./istanbul-start.sh
    echo "waiting 10 secs for network to sync up"
    sleep 60
else
    echo "############ Starting the network in raft mode #############"
    ./raft-init.sh
    ./raft-start-none.sh
fi

# deploy the contracts
echo "############ Deploying permissions related contarcts #############"
cd contracts
cp /Users/peter/IdeaProjects/go/src/github.com/ethereum/go-ethereum/controls/permission/*.sol .
./deploy.sh

# perform upgr.init
echo "############ Running upgradable init #############"
cd ../JS
./run-init.sh
sleep 5

echo "############ Stopping the network #############"

# bring down the network
cd ..
./stop.sh

sleep 5

# run perm-init.sh
echo "############ Executing permissions init #############"
./perm-init.sh

# bring up the network in permissioned mode
echo "############ Starting the network in permissioned mode #############"
if [ "$mode"  ==  "IBFT" ]
then
    echo "######### starting in IBFT mode to deploy the contracts ######"
    ./istanbul-start.sh
else
    echo "############ Starting the network in raft mode #############"
    ./raft-start.sh
fi
