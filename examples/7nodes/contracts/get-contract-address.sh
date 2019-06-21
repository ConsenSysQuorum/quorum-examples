#!/usr/bin/env bash
txid=$1

x=$(geth attach ipc:${EXAMPLENODEFOLDER}/qdata/dd1/geth.ipc <<EOF
var addr=eth.getTransactionReceipt("$txid").contractAddress;
console.log("contarct address number is :["+addr+"]");
exit;
EOF
)
contaddr=`echo $x| tr -s " "| cut -f2 -d "[" | cut -f1 -d"]"`
echo $contaddr