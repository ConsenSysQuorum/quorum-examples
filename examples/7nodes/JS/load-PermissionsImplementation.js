ac = eth.accounts[0];
web3.eth.defaultAccount = ac;
var abi = [{"constant":true,"inputs":[{"name":"_orgId","type":"string"},{"name":"_acct","type":"address"}],"name":"checkIfVoterExists","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_orgId","type":"string"}],"name":"getVoteCount","outputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_roleId","type":"string"},{"name":"_orgId","type":"string"}],"name":"getRoleDetails","outputs":[{"name":"","type":"string"},{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"bool"},{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_nwAdminOrg","type":"string"},{"name":"_nwAdminRole","type":"string"},{"name":"_oAdminRole","type":"string"}],"name":"setPolicy","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_acct","type":"address"}],"name":"getAccountDetails","outputs":[{"name":"","type":"address"},{"name":"","type":"string"},{"name":"","type":"string"},{"name":"","type":"uint256"},{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_acct","type":"address"},{"name":"_orgId","type":"string"},{"name":"_roleId","type":"string"}],"name":"assignAccountRole","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_orgManager","type":"address"},{"name":"_rolesManager","type":"address"},{"name":"_acctManager","type":"address"},{"name":"_voterManager","type":"address"},{"name":"_nodeManager","type":"address"}],"name":"init","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_enodeId","type":"string"}],"name":"getNodeStatus","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"updateNetworkBootStatus","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getNetworkBootStatus","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_orgIndex","type":"uint256"}],"name":"getOrgInfo","outputs":[{"name":"","type":"string"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"},{"name":"_orgId","type":"string"}],"name":"validateAccount","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_acct","type":"address"}],"name":"addAdminAccounts","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_orgId","type":"string"},{"name":"_enodeId","type":"string"},{"name":"_caller","type":"address"}],"name":"approveOrg","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_orgId","type":"string"},{"name":"_enodeId","type":"string"},{"name":"_caller","type":"address"}],"name":"addOrg","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"},{"name":"_caller","type":"address"}],"name":"approveOrgAdminAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_roleId","type":"string"},{"name":"_orgId","type":"string"},{"name":"_access","type":"uint256"},{"name":"_voter","type":"bool"}],"name":"addNewRole","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_orgId","type":"string"},{"name":"_account","type":"address"},{"name":"_caller","type":"address"}],"name":"assignOrgAdminAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_orgId","type":"string"}],"name":"getNumberOfVoters","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"},{"name":"_orgId","type":"string"}],"name":"isOrgAdmin","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_roleId","type":"string"},{"name":"_orgId","type":"string"}],"name":"removeRole","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_orgId","type":"string"},{"name":"_enodeId","type":"string"}],"name":"addNode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"isNetworkAdmin","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_enodeId","type":"string"}],"name":"addAdminNodes","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_orgId","type":"string"}],"name":"getPendingOp","outputs":[{"name":"","type":"string"},{"name":"","type":"string"},{"name":"","type":"address"},{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_permUpgradable","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_msg","type":"string"}],"name":"Dummy","type":"event"}];
var impl = web3.eth.contract(abi).at("0xfc6ada1b112701f833af9dea2d92623d00ce82ca");
