web3.eth.defaultAccount = eth.accounts[0];

var abi = [{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"tokens","type":"uint256"}],"name":"approve","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"from","type":"address"},{"name":"to","type":"address"},{"name":"tokens","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"tokenOwner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"to","type":"address"},{"name":"tokens","type":"uint256"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"tokenOwner","type":"address"},{"name":"spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_value","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"tokens","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"tokenOwner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"tokens","type":"uint256"}],"name":"Approval","type":"event"}];
var bytecode = "0x608060405234801561001057600080fd5b50604051602080610b338339810180604052810190808051906020019092919050505080600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508060008190555050610aa58061008e6000396000f300608060405260043610610078576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063095ea7b31461007d57806318160ddd146100e257806323b872dd1461010d57806370a0823114610192578063a9059cbb146101e9578063dd62ed3e1461024e575b600080fd5b34801561008957600080fd5b506100c8600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803590602001909291905050506102c5565b604051808215151515815260200191505060405180910390f35b3480156100ee57600080fd5b506100f76103b7565b6040518082815260200191505060405180910390f35b34801561011957600080fd5b50610178600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803590602001909291905050506103bd565b604051808215151515815260200191505060405180910390f35b34801561019e57600080fd5b506101d3600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610777565b6040518082815260200191505060405180910390f35b3480156101f557600080fd5b50610234600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803590602001909291905050506107c0565b604051808215151515815260200191505060405180910390f35b34801561025a57600080fd5b506102af600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506109f2565b6040518082815260200191505060405180910390f35b600081600260003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a36001905092915050565b60005481565b600081600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020541015801561048a575081600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410155b15156104fe576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260138152602001807f7472616e7366657246726f6d206661696c65640000000000000000000000000081525060200191505060405180910390fd5b81600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205403600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190555081600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205403600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190555081600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205401600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3600190509392505050565b6000600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b600081600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410151515610879576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252600f8152602001807f7472616e73666572206661696c6564000000000000000000000000000000000081525060200191505060405180910390fd5b81600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205403600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190555081600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205401600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a36001905092915050565b6000600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050929150505600a165627a7a72305820b36757bca681b9d80896f712bfc9147c4432a22742f6f7c7682af3bbf29e6de70029";

var erc20Contract = web3.eth.contract(abi);
var erc20 = erc20Contract.new(1000000, {from:web3.eth.accounts[0], data: bytecode, gas: 0x47b760}, function(e, contract) {
	if (e) {
		console.log("err creating contract", e);
	} else {
		if (!contract.address) {
			console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
		} else {
			console.log("Contract mined! Address: " + contract.address);
		}
	}
});

// pragma solidity >=0.4.22 <0.5.0;
// contract Token {
//
//     uint256 public totalSupply;
//     mapping(address => uint256) balances;
//     mapping(address => mapping (address => uint256)) allowed;
//
//     event Transfer(address indexed from, address indexed to, uint256 tokens);
//     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
//
//     constructor(uint256 _value) public {
//         balances[msg.sender] = _value;
//         totalSupply = _value;
//     }
//
//     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
//         return balances[tokenOwner];
//     }
//
//     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
//         return allowed[tokenOwner][spender];
//     }
//
//     function transfer(address to, uint256 tokens) public returns (bool success) {
//         require(balances[msg.sender] >= tokens, "transfer failed");
//         balances[msg.sender] = balances[msg.sender] - tokens;
//         balances[to] = balances[to] + tokens;
//         emit Transfer(msg.sender, to, tokens);
//         return true;
//     }
//
//     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
//         require(allowed[from][msg.sender] >= tokens && balances[from] >= tokens, "transferFrom failed");
//         balances[from] = balances[from] - tokens;
//         allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
//         balances[to] = balances[to] + tokens;
//         emit Transfer(from, to, tokens);
//         return true;
//     }
//
//     function approve(address spender, uint256 tokens) public returns (bool success) {
//         allowed[msg.sender][spender] = tokens;
//         emit Approval(msg.sender, spender, tokens);
//         return true;
//     }
//
// }
