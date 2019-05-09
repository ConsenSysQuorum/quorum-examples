ac = eth.accounts[0];
web3.eth.defaultAccount = ac;
var abi = [{"constant":true,"inputs":[],"name":"getPermImpl","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_proposedImpl","type":"address"}],"name":"confirmImplChange","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCustodian","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getPermInterface","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_permInterface","type":"address"},{"name":"_permImpl","type":"address"}],"name":"init","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[{"name":"_custodian","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];
var bytecode = "0x608060405234801561001057600080fd5b506040516020806102f38339810180604052602081101561003057600080fd5b505160008054600160a060020a03909216600160a060020a0319909216919091179055610291806100626000396000f3fe608060405234801561001057600080fd5b5060043610610073577c010000000000000000000000000000000000000000000000000000000060003504630e32cf90811461007857806322bcb39a1461009c578063c561d4b7146100c4578063e572515c146100cc578063f09a4016146100d4575b600080fd5b610080610102565b60408051600160a060020a039092168252519081900360200190f35b6100c2600480360360208110156100b257600080fd5b5035600160a060020a0316610111565b005b610080610163565b610080610172565b6100c2600480360360408110156100ea57600080fd5b50600160a060020a0381358116916020013516610181565b600154600160a060020a031690565b600054600160a060020a0316331461012857600080fd5b6001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a03838116919091179182905561016091166101e3565b50565b600054600160a060020a031690565b600254600160a060020a031690565b600054600160a060020a0316331461019857600080fd5b60018054600160a060020a0380841673ffffffffffffffffffffffffffffffffffffffff199283161792839055600280548683169316929092179091556101df91166101e3565b5050565b600254604080517f511bbd9f000000000000000000000000000000000000000000000000000000008152600160a060020a0384811660048301529151919092169163511bbd9f91602480830192600092919082900301818387803b15801561024a57600080fd5b505af115801561025e573d6000803e3d6000fd5b505050505056fea165627a7a723058200957d1ef8d2ab95e521060511b5cabb18a28839ace4a1b0581728d8c4fe2f5a80029";
var simpleContract = web3.eth.contract(abi);
var a = simpleContract.new("0xed9d02e382b34818e88b88a309c7fe71e65f419d",{from:web3.eth.accounts[0], data: bytecode, gas: 7200000}, function(e, contract) {
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
