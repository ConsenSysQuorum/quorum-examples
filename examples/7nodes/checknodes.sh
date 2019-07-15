#!/bin/bash

for i in {1..7}
do

x=$(geth attach ipc:qdata/dd${i}/geth.ipc <<EOF
console.log(admin.peers.length);
exit
EOF
)

echo $x | cut -d'>' -f2 | cut -d' ' -f2

done