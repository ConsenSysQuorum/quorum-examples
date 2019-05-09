#!/bin/bash
set -u
set -e
mode=$1
node=$2

echo "[*] Cleaning up temporary data directories"
rm -rf qdata/dd$node
#rm -rf qdata/dd6
#rm -rf qdata/dd7
mkdir -p qdata/logs

#if [ $node -eq 5 ]
#then
echo "[*] Configuring node $node"
mkdir -p qdata/dd$node/{keystore,geth}
#cp qdata/dd1/permissioned-nodes.json qdata/dd$node/static-nodes.json
cp ./perm$node.json qdata/dd$node/static-nodes.json
#cp ./perm$node.json qdata/dd$node/permissioned-nodes.json
cp ./permission-config.json qdata/dd$node/
cp qdata/dd1/permissioned-nodes.json qdata/dd$node/permissioned-nodes.json
cp keys/key$node qdata/dd$node/keystore
if [ "$mode" == "RAFT" ]
then
	cp raft/nodekey$node qdata/dd$node/geth/nodekey
	geth --datadir qdata/dd$node init genesis.json
else
	cp raft/nodekey$node qdata/dd$node/geth/nodekey
	geth --datadir qdata/dd$node init istanbul-genesis.json
fi
./tessera-init57.sh $node
