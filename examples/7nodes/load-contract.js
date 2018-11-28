a = eth.accounts[0]
web3.eth.defaultAccount = a;
var abi = [{"constant":true,"inputs":[],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"}];
//var simple = web3.eth.contract(abi).at("0xd9d64b7dc034fafdba5dc2902875a67b5d586420")
var simple = web3.eth.contract(abi).at("0x9d13c6d3afe1721beef56b55d303b09e021e27ab")
