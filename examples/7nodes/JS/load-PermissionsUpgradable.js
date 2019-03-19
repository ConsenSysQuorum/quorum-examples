ac = eth.accounts[0];
web3.eth.defaultAccount = ac;
var abi = [{"constant":true,"inputs":[],"name":"getPermImpl","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_proposedImpl","type":"address"}],"name":"confirmImplChange","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCustodian","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getPermInterface","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_permInterface","type":"address"},{"name":"_permImpl","type":"address"}],"name":"init","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_custodian","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];
var upgr = web3.eth.contract(abi).at("0xd868af212ab980042df6e5505d440728305d028f");
var impl = "0xfc6ada1b112701f833af9dea2d92623d00ce82ca"
var intr = "0xcc0df441f4f03f86b64fe9a4d09520c0fb3bdecd"
var up = "0xd868af212ab980042df6e5505d440728305d028f"
