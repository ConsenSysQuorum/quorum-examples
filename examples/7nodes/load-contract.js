a = eth.accounts[0]
web3.eth.defaultAccount = a;
var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"payable":false,"type":"constructor"}];
//var simple = web3.eth.contract(abi).at("0xd9d64b7dc034fafdba5dc2902875a67b5d586420")
var simple = web3.eth.contract(abi).at("0xf0aab87d559472deb75c0353225ee9e71b9c2abb")
