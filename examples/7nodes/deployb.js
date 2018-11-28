a = eth.accounts[0]
web3.eth.defaultAccount = a;

var abi = [{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"setc","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"b","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getc","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getb","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"setb","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"initVal","type":"uint256"},{"name":"_addrc","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];

var bytecode = "0x608060405234801561001057600080fd5b50604051604080610356833981016040528051602090910151600091825560018054600160a060020a031916600160a060020a039092169190911790556102f990819061005d90396000f30060806040526004361061006c5763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166343d3e76781146100715780634df7e3d01461008b5780636dd1f0ed146100b25780637b52af64146100c7578063b01d41ee146100dc575b600080fd5b34801561007d57600080fd5b506100896004356100f4565b005b34801561009757600080fd5b506100a0610182565b60408051918252519081900360200190f35b3480156100be57600080fd5b506100a0610188565b3480156100d357600080fd5b506100a0610225565b3480156100e857600080fd5b5061008960043561022b565b600154604080517f43d3e76700000000000000000000000000000000000000000000000000000000815260048101849052905173ffffffffffffffffffffffffffffffffffffffff909216916343d3e7679160248082019260009290919082900301818387803b15801561016757600080fd5b505af115801561017b573d6000803e3d6000fd5b5050505050565b60005481565b600154604080517f6dd1f0ed000000000000000000000000000000000000000000000000000000008152905160009273ffffffffffffffffffffffffffffffffffffffff1691636dd1f0ed91600480830192602092919082900301818787803b1580156101f457600080fd5b505af1158015610208573d6000803e3d6000fd5b505050506040513d602081101561021e57600080fd5b5051905090565b60005490565b600154604080517f6dd1f0ed000000000000000000000000000000000000000000000000000000008152905160009273ffffffffffffffffffffffffffffffffffffffff1691636dd1f0ed91600480830192602092919082900301818787803b15801561029757600080fd5b505af11580156102ab573d6000803e3d6000fd5b505050506040513d60208110156102c157600080fd5b505191909102600055505600a165627a7a723058204b1368d71419a83680263df9360cd95595fcac34c5e884a58d5495fb93bceb8d0029";

var simpleContract = web3.eth.contract(abi);
var b = simpleContract.new(1,"0x1932c48b2bf8102ba33b4a6b545c32236e342f34", {from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760, privateFor: ["QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="]}, function(e, contract) {
// var b = simpleContract.new(9, "0xa501afd7d6432718daf4458cfae8590d88de818e", {from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760}, function(e, contract) {
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
