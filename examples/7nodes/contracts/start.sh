#!/usr/bin/env bash
set -u
set -e

cd ..

./stop.sh

# run raft-init.sh
echo "############ Starting the network in un-permissioned mode #############"
./raft-init.sh
# bring up the network in un-permissioned mode
./uraft-start.sh

# deploy the contracts
echo "############ Deploying permissions related contarcts #############"
cd contracts
cp /Users/saiv/go/src/github.com/ethereum/go-ethereum/controls/permission/*.sol .
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
./raft-start.sh
