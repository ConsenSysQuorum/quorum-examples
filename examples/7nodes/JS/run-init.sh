#!/usr/bin/env bash
txid=$1

x=$(geth attach ipc:${EXAMPLENODEFOLDER}/qdata/dd1/geth.ipc <<EOF
loadScript("load-PermissionsUpgradable.js");
var tx = upgr.init(intr, impl, {from: eth.accounts[0], gas: 4500000});
console.log("contarct address number is :["+tx+"]");
exit;
EOF
)