#!/usr/bin/env bash
txid=$1

x=$(geth attach ipc:/Users/saiv/work/quorum-examples/examples/7nodes/qdata/dd1/geth.ipc <<EOF
loadScript("load-PermissionsUpgradable.js");
var tx = upgr.init(intr, impl, {from: eth.accounts[0], gas: 4500000});
loadScript("load-PermissionsInterface.js");
var y = intr.setPolicy("NWADMIN", "NWADMIN", "OADMIN", {from: eth.accounts[0], gas: 4500000})
var y = intr.init(oc, rc, ac, vc, nc, 3, 3, {from: eth.accounts[0], gas:45000000})
var x = "enode://3701f007bfa4cb26512d7df18e6bbd202e8484a6e11d387af6e482b525fa25542d46ff9c99db87bd419b980c24a086117a397f6d8f88e74351b41693880ea0cb@127.0.0.1:21004?discport=0&raftport=50405"
var y = intr.addAdminNodes(x, {from: eth.accounts[0], gas: 450000})
var y = intr.addAdminAccounts(eth.accounts[0], {from: eth.accounts[0], gas:4500000})
var y = intr.updateNetworkBootStatus({from: eth.accounts[0], gas: 450000})
var x = "enode://1abef086386150ce617702af935a93b45428b86f1d509a3802ccadd0cbb351cc4df8fe983afd88cb274c36e00b2a7755c175d6088de91d2e0e7d8d3a380ad787@127.0.0.1:21005?discport=0"
var y = intr.addOrg("ABC", x, "0xca843569e3427144cead5e4d5999a3d0ccf92b8e", {from: eth.accounts[0], gas: 45000000})
var y = intr.approveOrg("ABC", x, "0xca843569e3427144cead5e4d5999a3d0ccf92b8e", {from: eth.accounts[0], gas: 45000000})
exit;
EOF
)
