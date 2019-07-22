#!/bin/bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node 1 (permissioned)"
mkdir -p qdata/dd1/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd1/static-nodes.json
cp permissioned-nodes-Node4HA.json qdata/dd1/permissioned-nodes.json
cp keys/key1 qdata/dd1/keystore
cp raft/nodekey1 qdata/dd1/geth/nodekey
geth --datadir qdata/dd1 init genesis.json

echo "[*] Configuring node 2 (permissioned)"
mkdir -p qdata/dd2/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd2/static-nodes.json
cp permissioned-nodes-Node4HA.json qdata/dd2/permissioned-nodes.json
cp keys/key2 qdata/dd2/keystore
cp raft/nodekey2 qdata/dd2/geth/nodekey
geth --datadir qdata/dd2 init genesis.json

echo "[*] Configuring node 3 (permissioned)"
mkdir -p qdata/dd3/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd3/static-nodes.json
cp permissioned-nodes-Node4HA.json qdata/dd3/permissioned-nodes.json
cp keys/key6 qdata/dd3/keystore
cp keys/key3 qdata/dd3/keystore
cp raft/nodekey3 qdata/dd3/geth/nodekey
geth --datadir qdata/dd3 init genesis.json

echo "[*] Configuring node 41 (permissioned)"
mkdir -p qdata/dd41/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd41/static-nodes.json
cp permissioned-nodes-Node4HA.json qdata/dd41/permissioned-nodes.json
cp keys/key4 qdata/dd41/keystore
cp raft/nodekey4 qdata/dd41/geth/nodekey
geth --datadir qdata/dd41 init genesis.json

echo "[*] Configuring node 42"
mkdir -p qdata/dd42/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd42/static-nodes.json
cp keys/key4 qdata/dd42/keystore
cp raft/nodekey8 qdata/dd42/geth/nodekey
geth --datadir qdata/dd42 init genesis.json

echo "[*] Configuring node 5"
mkdir -p qdata/dd5/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd5/static-nodes.json
cp keys/key5 qdata/dd5/keystore
cp raft/nodekey5 qdata/dd5/geth/nodekey
geth --datadir qdata/dd5 init genesis.json

echo "[*] Configuring node 6"
mkdir -p qdata/dd6/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd6/static-nodes.json
cp raft/nodekey6 qdata/dd6/geth/nodekey
cp keys/key7 qdata/dd6/keystore
geth --datadir qdata/dd6 init genesis.json

echo "[*] Configuring node 7"
mkdir -p qdata/dd7/{keystore,geth}
cp permissioned-nodes-Node4HA.json qdata/dd7/static-nodes.json
cp raft/nodekey7 qdata/dd7/geth/nodekey
cp keys/key8 qdata/dd7/keystore
geth --datadir qdata/dd7 init genesis.json

#Initialise Tessera configuration
./tessera-init.sh

cp ./tessera-nginx/configs/tessera-config-09-41.json ./qdata/c4/
cp ./tessera-nginx/configs/tessera-config-09-42.json ./qdata/c4/