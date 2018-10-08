#!/bin/bash
set -u
set -e

node=$1

NETWORK_ID=$(cat istanbul-genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

if [ $NETWORK_ID -eq 1 ]
then
	echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	echo "  1337 is the recommend ChainId for Geth private clients."
fi

mkdir -p qdata/logs
echo "[*] Starting Constellation nodes"
./57const.sh $node

let i=$node-1

echo "[*] Starting Ethereum nodes with ChainID and NetworkId of $NETWORK_ID"
set -v
ARGS="--gcmode full --permissioned --istanbul.blockperiod 2 --networkid $NETWORK_ID --syncmode full --mine --minerthreads 1 --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul"
echo "Starting node $node"
PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth --datadir qdata/dd$node $ARGS --rpcport 2200$i --port 2100$i --unlock 0 --password passwords.txt 2>>qdata/logs/$node.log &
set +v

echo
echo "All nodes configured. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/dd1/geth.ipc' to attach to the first Geth node."
echo "To test sending a private transaction from Node 1 to Node 7, run './runscript.sh private-contract.js'"
