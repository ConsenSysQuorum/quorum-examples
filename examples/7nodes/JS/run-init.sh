#!/usr/bin/env bash
txid=$1

x=$(geth attach ipc:/Users/saiv/work/quorum-examples/examples/7nodes/qdata/dd1/geth.ipc <<EOF
loadScript("load-PermissionsUpgradable.js");
var tx = upgr.init(intr, impl, {from: eth.accounts[0], gas: 4500000});
console.log("contarct address number is :["+tx+"]");
exit;
EOF
)