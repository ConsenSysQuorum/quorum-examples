ac = eth.accounts[0];
web3.eth.defaultAccount = ac;
var abi = [{"constant":true,"inputs":[{"name":"_acct","type":"address"},{"name":"_orgId","type":"string"}],"name":"checkOrgAdmin","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_acct","type":"address"}],"name":"getAccountDetails","outputs":[{"name":"","type":"address"},{"name":"","type":"string"},{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"},{"name":"_orgId","type":"string"},{"name":"_roleId","type":"string"}],"name":"assignAccountRole","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getNumberOfAccounts","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_acct","type":"address"},{"name":"_orgId","type":"string"}],"name":"valAcctAccessChange","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_acct","type":"address"}],"name":"getAccountRole","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_orgId","type":"string"}],"name":"orgAdminExists","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"},{"name":"_orgId","type":"string"}],"name":"addNWAdminAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_nwAdminRole","type":"string"},{"name":"_oAdminRole","type":"string"}],"name":"setDefaults","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"approveOrgAdminAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"revokeAccountRole","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_permUpgradable","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_address","type":"address"},{"indexed":false,"name":"_roleId","type":"string"}],"name":"AccountAccessModified","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_address","type":"address"},{"indexed":false,"name":"_roleId","type":"string"}],"name":"AccountAccessRevoked","type":"event"}];
var a = web3.eth.contract(abi).at("0x5bd2d9d763d783e726dfc06bd06588be006ef554");
