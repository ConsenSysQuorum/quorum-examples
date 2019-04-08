#!/bin/bash
set -u
set -e
node=$1

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
cp raft/nodekey$node qdata/dd$node/geth/nodekey
geth --datadir qdata/dd$node init genesis.json

#let x=$node-1
#for (( i=1; i<=$x; i++ ))
#do
#	DDIR="qdata/dd$i"
#	cp "perm$node.json" "$DDIR/permissioned-nodes.json"
#done
./tessera-init57.sh $node
