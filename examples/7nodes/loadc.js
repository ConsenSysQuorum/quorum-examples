ac = eth.accounts[0]
web3.eth.defaultAccount = ac;
var abi = [{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"setc","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getc","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"c","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"pval","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];

var c = web3.eth.contract(abi).at("0x1932c48b2bf8102ba33b4a6b545c32236e342f34");
