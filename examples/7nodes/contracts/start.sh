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
    ./istanbul-start-none.sh
    echo "waiting 60 secs for network to sync up"
    for i in {1..50}
    do
        sleep 1
        echo $i
    done
else
    echo "############ Starting the network in raft mode #############"
    ./raft-init.sh
    ./raft-start-none.sh
fi

# deploy the contracts
echo "############ Deploying permissions related contarcts #############"
cd contracts
cp /Users/peter/IdeaProjects/go/src/github.com/ethereum/go-ethereum/permission/contract/*.sol .
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
    ./istanbul-start-ignore.sh
else
    echo "############ Starting the network in raft mode #############"
    ./raft-start.sh
fi
