#!/bin/bash
set -u
set -e

function usage() {
    echo ""
    echo "Usage:"
    echo "    $0 [tessera | constellation] [--tesseraOptions \"options for Tessera start script\"]"
    echo ""
    echo "Where:"
    echo "    tessera | constellation (default = constellation): specifies which privacy implementation to use"
    echo "    --tesseraOptions: allows additional options as documented in tessera-start.sh usage which is shown below:"
    echo ""
    ./tessera-start.sh --help
    exit -1
}

privacyImpl=tessera
tesseraOptions=
while (( "$#" )); do
    case "$1" in
        tessera)
            privacyImpl=tessera
            shift
            ;;
        constellation)
            privacyImpl=constellation
            shift
            ;;
        --tesseraOptions)
            tesseraOptions=$2
            shift 2
            ;;
        --node)
            node=$2
            shift 2
            ;;
        --raftid)
            raftid=$2
            shift 2
            ;;
        --help)
            shift
            usage
            ;;
        *)
            echo "Error: Unsupported command line parameter $1"
            usage
            ;;
    esac
done

NETWORK_ID=$(cat genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

if [ $NETWORK_ID -eq 1 ]
then
	echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	echo "  1337 is the recommend ChainId for Geth private clients."
fi

mkdir -p qdata/logs
if [ "$privacyImpl" == "tessera" ]; then
    echo "[*] Starting Tessera nodes"
    echo "----------------------------"
    echo "${tesseraOptions}"
    echo "$node"
    echo "----------------------------"
    ./tessera-start57.sh ${tesseraOptions} --nodelow $node --nodehigh $node
elif [ "$privacyImpl" == "constellation" ]; then
    echo "[*] Starting Constellation nodes"
    ./constellation-start.sh
else
    echo "Unsupported privacy implementation: ${privacyImpl}"
    usage
fi


let i=$node-1

echo "[*] Starting Ethereum nodes with ChainID and NetworkId of $NETWORK_ID"
set -v
#ARGS="--networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi quorumAcctMgmt,quorumNodeMgmt,quorumOrgMgmt,admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
ARGS="--networkid $NETWORK_ID --permissioned --raft --rpc --rpcaddr 0.0.0.0 --rpcapi quorumAcctMgmt,quorumNodeMgmt,quorumOrgMgmt,admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
echo "Starting node $node"
PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth --datadir qdata/dd$node $ARGS --raftport 5040$node --raftjoinexisting $raftid --rpcport 2200$i --port 2100$i --unlock 0 --password passwords.txt 2>>qdata/logs/$node.log &
set +v

echo
echo "All nodes configured. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/dd1/geth.ipc' to attach to the first Geth node."
echo "To test sending a private transaction from Node 1 to Node 7, run './runscript.sh private-contract.js'"
