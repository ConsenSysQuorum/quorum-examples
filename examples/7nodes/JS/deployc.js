ac = eth.accounts[0]
web3.eth.defaultAccount = ac;

var abi = [{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"setc","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getc","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"c","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"pval","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];

var bytecode = "0x608060405234801561001057600080fd5b50604051602080610114833981016040525160005560e1806100336000396000f30060806040526004361060525763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166343d3e767811460575780636dd1f0ed14606e578063c3da42b8146092575b600080fd5b348015606257600080fd5b50606c60043560a4565b005b348015607957600080fd5b50608060a9565b60408051918252519081900360200190f35b348015609d57600080fd5b50608060af565b600055565b60005490565b600054815600a165627a7a72305820f906bc72c10eb953be4ab8435fdd4bfbb948529d12a7a2bfaa8c16cbf5364e6b0029";
var simpleContract = web3.eth.contract(abi);
var c = simpleContract.new(9,{from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760, privateFor: ["QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="]}, function(e, contract) {
// var c = simpleContract.new(9, {from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760}, function(e, contract) {
	if (e) {
		console.log("err creating contract", e);
	} else {
		if (!contract.address) {
			console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
		} else {
			console.log("Contract mined! Address: " + contract.address);
			console.log(contract);
		}
	}
});
