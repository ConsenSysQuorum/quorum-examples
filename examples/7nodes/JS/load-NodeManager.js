ac = eth.accounts[0];
web3.eth.defaultAccount = ac;
var abi = [{"constant":false,"inputs":[{"name":"_enodeId","type":"string"}],"name":"approveNode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_enodeId","type":"string"}],"name":"getNodeStatus","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"enodeId","type":"string"}],"name":"getNodeDetails","outputs":[{"name":"_enodeId","type":"string"},{"name":"_nodeStatus","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_enodeId","type":"string"},{"name":"_orgId","type":"string"}],"name":"addOrgNode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"nodeIndex","type":"uint256"}],"name":"getNodeDetailsFromIndex","outputs":[{"name":"_enodeId","type":"string"},{"name":"_nodeStatus","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_enodeId","type":"string"},{"name":"_orgId","type":"string"}],"name":"addNode","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getNumberOfNodes","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_permUpgradable","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodeProposed","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodeApproved","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodePendingDeactivation","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodeDeactivated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodePendingActivation","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodeActivated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_enodeId","type":"string"}],"name":"NodePendingBlacklist","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"}],"name":"NodeBlacklisted","type":"event"}];
var n = web3.eth.contract(abi).at("0x8abc11953464fd243a21280d63f353812919c858");
