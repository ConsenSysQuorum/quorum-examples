# Privacy Enhancements Examples

## Running
Please ensure that your sample network has privacy enhancements enabled (the config section in the genesis.json has the `"privacyEnhancementsBlock": 0` element). 

###Party Protection
Replace the contract addresses/transaction hashes below with the addresses/hashes resulting from deploying the relevant contract/sending the relevant transaction. 

Attach to node1 geth console:
```shell script
$ geth attach qdata/dd1/geth.ipc 
```
Deploy a party protection simple storage contract between node1, node3 and node4:
```shell script
> loadScript("samples/privacy-enhancements/private-contract-partyProtection.js")
Contract transaction send: TransactionHash: 0x745b9688843f5f81179f531173a627e2a8499f9724a94175c8ee061c368eee02 waiting to be mined...
true
> Contract mined! Address: 0x426886107ed52c22b4735adc77c8f1e0bf08746d
[object Object]
```
Check the privacy metadata for the newly created contract:
```shell script
> eth.getContractPrivacyMetadata("0x426886107ed52c22b4735adc77c8f1e0bf08746d")
{
  creationTxHash: [14, 173, 253, 225, 6, 27, 122, 46, 123, 44, 87, 33, 30, 4, 131, 187, 60, 27, 199, 108, 218, 94, 242, 190, 91, 44, 77, 53, 219, 50, 101, 188, 254, 129, 239, 159, 100, 119, 198, 233, 105, 34, 18, 210, 35, 93, 125, 255, 227, 240, 6, 197, 231, 139, 225, 16, 243, 214, 158, 38, 191, 153, 174, 113],
  privacyFlag: 1
}
```
Attach to node4 geth console:
```shell script
$ geth attach qdata/dd4/geth.ipc 
```
Verify the privacy metadata for the newly created contract is the same as in node1:
```shell script
> eth.getContractPrivacyMetadata("0x426886107ed52c22b4735adc77c8f1e0bf08746d")
{
  creationTxHash: [14, 173, 253, 225, 6, 27, 122, 46, 123, 44, 87, 33, 30, 4, 131, 187, 60, 27, 199, 108, 218, 94, 242, 190, 91, 44, 77, 53, 219, 50, 101, 188, 254, 129, 239, 159, 100, 119, 198, 233, 105, 34, 18, 210, 35, 93, 125, 255, 227, 240, 6, 197, 231, 139, 225, 16, 243, 214, 158, 38, 191, 153, 174, 113],
  privacyFlag: 1
}
```
Attach to node2 geth console:
```shell script
$ geth attach qdata/dd2/geth.ipc 
```
Verify the privacy metadata for the newly created contract does not exist on node2:
```shell script
> eth.getContractPrivacyMetadata("0x426886107ed52c22b4735adc77c8f1e0bf08746d");
Error: The provided contract does not have privacy metadata: 426886107ed52c22b4735adc77c8f1e0bf08746d
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at <anonymous>:1:1

```
Try to send a party protection transaction from node2 that attempts to alter the contract state:
```shell script
> var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"type":"constructor"}];
> var private = eth.contract(abi).at("0x426886107ed52c22b4735adc77c8f1e0bf08746d")
> private.set(4,{from:eth.accounts[0],privateFor:["oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="], privacyFlag:1});
Error: contract not found. cannot transact
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at web3.js:4137:16
    at apply (<native code>)
    at web3.js:4223:16
    at <anonymous>:1:1
```
Send a standard private (observe the privacyFlag is missing) transaction from node2 that attempts to alter the contract state:
```shell script
> private.set(4,{from:eth.accounts[0],privateFor:["oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="]});

"0x0963403ff2f0c7c2f04e4e03a16434123545a5cfda67b8c61c2f7df5fa490f83"
```
Check the transaction receipt on node2 (observe the 0x1 status which means that the transaction is successful):
```shell script
> eth.getTransactionReceipt("0x0963403ff2f0c7c2f04e4e03a16434123545a5cfda67b8c61c2f7df5fa490f83")
{
  blockHash: "0x010e463521c74f639a9b58dfd2c1af2ecc2345a62f80d3d4afa21a1f598dcb30",
  blockNumber: 223,
  contractAddress: null,
  cumulativeGasUsed: 0,
  from: "0xca843569e3427144cead5e4d5999a3d0ccf92b8e",
  gasUsed: 0,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x1",
  to: "0x426886107ed52c22b4735adc77c8f1e0bf08746d",
  transactionHash: "0x0963403ff2f0c7c2f04e4e03a16434123545a5cfda67b8c61c2f7df5fa490f83",
  transactionIndex: 0
}
```
Check the transaction receipt on node4 (observe the 0x0 status which means that the transaction has failed):
```shell script
> eth.getTransactionReceipt("0x0963403ff2f0c7c2f04e4e03a16434123545a5cfda67b8c61c2f7df5fa490f83")
{
  blockHash: "0x010e463521c74f639a9b58dfd2c1af2ecc2345a62f80d3d4afa21a1f598dcb30",
  blockNumber: 223,
  contractAddress: null,
  cumulativeGasUsed: 0,
  from: "0xca843569e3427144cead5e4d5999a3d0ccf92b8e",
  gasUsed: 0,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x0",
  to: "0x426886107ed52c22b4735adc77c8f1e0bf08746d",
  transactionHash: "0x0963403ff2f0c7c2f04e4e03a16434123545a5cfda67b8c61c2f7df5fa490f83",
  transactionIndex: 0
}
```
Send a transaction from node1 to node3 updating the contract state (node4 is not a party to this transaction):
```shell script
> var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"type":"constructor"}];
> var private = eth.contract(abi).at("0x426886107ed52c22b4735adc77c8f1e0bf08746d")
> private.set(5,{from:eth.accounts[0],privateFor:["1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="], privacyFlag:1});
"0xabb21867361843300bb0853ce50ab5392116b6137350cbb2b7a55fe5b5901f0a"
```
Verify that the simple storage contract value on node1 and node3 is 5 while on node4 it is 42 (the party protection privacyFlag allows sending a transaction to a subset of the participants).



###Private state validation
Replace the contract addresses/transaction hashes below with the addresses/hashes resulting from deploying the relevant contract/sending the relevant transaction. 

Attach to node1 geth console:
```shell script
$ geth attach qdata/dd1/geth.ipc 
```
Deploy a PSV simple storage contract between node1, node3 and node4:
```shell script
loadScript("samples/privacy-enhancements/private-contract-PSV.js")
Contract transaction send: TransactionHash: 0x7623351e3b7eea4ca5c1437cad8b33c869e5cc64d4d3c300a8b6c74bbfdc5c59 waiting to be mined...
true
> Contract mined! Address: 0x4f2748cdb215191ec590a8dae5f17765eab48b19
[object Object]
```
Check the privacy metadata for the newly created contract:
```shell script
> eth.getContractPrivacyMetadata("0x4f2748cdb215191ec590a8dae5f17765eab48b19")
{
  creationTxHash: [72, 62, 149, 218, 128, 56, 162, 60, 48, 5, 215, 231, 246, 210, 140, 184, 121, 215, 190, 175, 229, 120, 72, 27, 246, 197, 51, 226, 139, 59, 161, 238, 30, 1, 18, 89, 207, 43, 189, 161, 55, 240, 240, 183, 143, 107, 152, 80, 197, 32, 159, 214, 146, 175, 45, 235, 244, 34, 223, 193, 255, 194, 65, 165],
  privacyFlag: 3
}
```
Attach to node4 geth console:
```shell script
$ geth attach qdata/dd4/geth.ipc 
```
Verify the privacy metadata for the newly created contract is the same as in node1:
```shell script
> eth.getContractPrivacyMetadata("0x4f2748cdb215191ec590a8dae5f17765eab48b19")
{
  creationTxHash: [72, 62, 149, 218, 128, 56, 162, 60, 48, 5, 215, 231, 246, 210, 140, 184, 121, 215, 190, 175, 229, 120, 72, 27, 246, 197, 51, 226, 139, 59, 161, 238, 30, 1, 18, 89, 207, 43, 189, 161, 55, 240, 240, 183, 143, 107, 152, 80, 197, 32, 159, 214, 146, 175, 45, 235, 244, 34, 223, 193, 255, 194, 65, 165],
  privacyFlag: 3
}
```
Attach to node2 geth console:
```shell script
$ geth attach qdata/dd2/geth.ipc 
```
Verify the privacy metadata for the newly created contract does not exist on node2:
```shell script
> eth.getContractPrivacyMetadata("0x4f2748cdb215191ec590a8dae5f17765eab48b19")
Error: The provided contract does not have privacy metadata: 4f2748cdb215191ec590a8dae5f17765eab48b19
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at <anonymous>:1:1
```
Try to send a PSV transaction from node2 that attempts to alter the contract state:
```shell script
> var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"type":"constructor"}];
> var private = eth.contract(abi).at("0x4f2748cdb215191ec590a8dae5f17765eab48b19")
> private.set(4,{from:eth.accounts[0],privateFor:["oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="], privacyFlag:3});
Error: contract not found. cannot transact
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at web3.js:4137:16
    at apply (<native code>)
    at web3.js:4223:16
    at <anonymous>:1:1
```
Send a standard private (observe the privacyFlag is missing) transaction from node2 that attempts to alter the contract state:
```shell script
> private.set(4,{from:eth.accounts[0],privateFor:["oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8=", "1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="]});

"0x470655707661abb9a1f0d1ad7c680fb2862f470ed88574365878739823fcf3c5"
```
Check the transaction receipt on node2 (observe the 0x1 status which means that the transaction is successful):
```shell script
> eth.getTransactionReceipt("0x470655707661abb9a1f0d1ad7c680fb2862f470ed88574365878739823fcf3c5")
{
  blockHash: "0x3eeb304dcf0f082b0f374c9988872b3e6c9eeb897fac8c0e6dede24ff8d0a43e",
  blockNumber: 226,
  contractAddress: null,
  cumulativeGasUsed: 0,
  from: "0xca843569e3427144cead5e4d5999a3d0ccf92b8e",
  gasUsed: 0,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x1",
  to: "0x4f2748cdb215191ec590a8dae5f17765eab48b19",
  transactionHash: "0x470655707661abb9a1f0d1ad7c680fb2862f470ed88574365878739823fcf3c5",
  transactionIndex: 0
}
```
Check the transaction receipt on node4 (observe the 0x0 status which means that the transaction has failed):
```shell script
> eth.getTransactionReceipt("0x470655707661abb9a1f0d1ad7c680fb2862f470ed88574365878739823fcf3c5")
{
  blockHash: "0x3eeb304dcf0f082b0f374c9988872b3e6c9eeb897fac8c0e6dede24ff8d0a43e",
  blockNumber: 226,
  contractAddress: null,
  cumulativeGasUsed: 0,
  from: "0xca843569e3427144cead5e4d5999a3d0ccf92b8e",
  gasUsed: 0,
  logs: [],
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  status: "0x0",
  to: "0x4f2748cdb215191ec590a8dae5f17765eab48b19",
  transactionHash: "0x470655707661abb9a1f0d1ad7c680fb2862f470ed88574365878739823fcf3c5",
  transactionIndex: 0
}
```
Try to send a transaction from node1 to node3 updating the contract state (node4 is not a party to this transaction):
```shell script
> var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"type":"constructor"}];
> var private = eth.contract(abi).at("0x4f2748cdb215191ec590a8dae5f17765eab48b19")
> private.set(5,{from:eth.accounts[0],privateFor:["1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg="], privacyFlag:3});
Error: 500 status: Recipients mismatched for Affected Txn SD6V2oA4ojwwBdfn9tKMuHnXvq/leEgb9sUz4os7oe4eARJZzyu9oTfw8LePa5hQxSCf1pKvLev0It/B/8JBpQ==. TxHash=NONE
    at web3.js:3143:20
    at web3.js:6347:15
    at web3.js:5081:36
    at web3.js:4137:16
    at apply (<native code>)
    at web3.js:4223:16
    at <anonymous>:1:1
```
The transaction fails due to mismatched recipients.

Send a transaction from node3 to node1 and node4 updating the contract state:
```shell script
> var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"type":"constructor"}];
> var private = eth.contract(abi).at("0x4f2748cdb215191ec590a8dae5f17765eab48b19")
> private.set(5,{from:eth.accounts[0],privateFor:["BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo=", "oNspPPgszVUFw0qmGFfWwh1uxVUXgvBxleXORHj07g8="], privacyFlag:3});
"0x9289f47b18910eef1913cb384e4d966c531f0774e9c30bea3283aae2fb94c081"
```
Verify that the simple storage contract has the value 5 on node1, node3 and node4. 

