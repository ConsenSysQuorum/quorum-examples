ac = eth.accounts[0];
web3.eth.defaultAccount = ac;
var abi = [{"constant":true,"inputs":[],"name":"getPermImpl","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_proposedImpl","type":"address"}],"name":"confirmImplChange","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCustodian","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getPermInterface","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_permInterface","type":"address"},{"name":"_permImpl","type":"address"}],"name":"init","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_custodian","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];
var upgr = web3.eth.contract(abi).at("0x1932c48b2bf8102ba33b4a6b545c32236e342f34");
var impl = "0xfe0602d820f42800e3ef3f89e1c39cd15f78d283"
var intr = "0x4d3bfd7821e237ffe84209d8e638f9f309865b87"
var up = "0x1932c48b2bf8102ba33b4a6b545c32236e342f34"
