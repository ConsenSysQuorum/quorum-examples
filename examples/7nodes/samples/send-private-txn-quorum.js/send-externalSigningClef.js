const quorumjs = require("quorum-js");
const Web3 = require("web3");
const request = require("request-promise-native");
// tessera 1 public key
const TM1_PUBLIC_KEY = "BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo=";
// tessera 7 public key
const TM7_PUBLIC_KEY = "ROAZBWtSacxXQrOe3FGAqJDyJjFePR5ce4TSIzmJ0Bc=";

// the account to use for signing (public address)
const accAddress = "0x7697fe4f8ed9496936354e95ffddd534af02a79d";

// simple storage contract bytecode
const simpleStorageContractBytecode = "0x6060604052341561000f57600080fd5b604051602080610149833981016040528080519060200190919050505b806000819055505b505b610104806100456000396000f30060606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632a1afcd914605157806360fe47b11460775780636d4ce63c146097575b600080fd5b3415605b57600080fd5b606160bd565b6040518082815260200191505060405180910390f35b3415608157600080fd5b6095600480803590602001909190505060c3565b005b341560a157600080fd5b60a760ce565b6040518082815260200191505060405180910390f35b60005481565b806000819055505b50565b6000805490505b905600a165627a7a72305820d5851baab720bba574474de3d09dbeaabc674a15f4dd93b974908476542c23f00029";

// simple storage contract ABI
const simpleStorageABI = [{
    constant: true,
    inputs: [],
    name: "storedData",
    outputs: [{
        name: "",
        type: "uint256"
    }],
    payable: false,
    type: "function"
}, {
    constant: false,
    inputs: [{
        name: "x",
        type: "uint256"
    }],
    name: "set",
    outputs: [],
    payable: false,
    type: "function"
}, {
    constant: true,
    inputs: [],
    name: "get",
    outputs: [{
        name: "retVal",
        type: "uint256"
    }],
    payable: false,
    type: "function"
}, {
    inputs: [{
        name: "initVal",
        type: "uint256"
    }],
    payable: false,
    type: "constructor"
}];


// Web3 entry point - used to talk to the quorum node
const web3 = new Web3(
    new Web3.providers.HttpProvider("http://localhost:22000")
);

// the RawTransactionManager - used to talk to tessera and quorum (via web3)
const rawTransactionManager = quorumjs.RawTransactionManager(web3, {
    // this is the Tessera third party APP URL (see the tessera config)
    privateUrl: "http://localhost:9081"
});

// the clef RPC URL
const clefUrl = "http://localhost:8550/";

// this function performs the transaction signing. Please replace this with your preferred signing mechanism.
// !!!IMPORTANT!!! - private transactions must be signed using the Homestead/Frontier signer
async function signTransaction(txnParams) {
    // using ethereum-tx to to sign the input transaction
    // this is the 7nodes keys/key1 account

    const rawTransaction = {
        nonce: `0x${(txnParams.nonce).toString(16)}`,
        from: accAddress,
        to: null,
        value: `0x${(txnParams.value).toString(16)}`,
        gas: `0x${(txnParams.gasLimit).toString(16)}`,
        gasPrice: `0x${(txnParams.gasPrice).toString(16)}`,
        data: `0x${txnParams.data}`,
        // this only applies to a customized clef. The vanilla clef will not use HomesteadSigner to sign transactions.
        isPrivate: true
    };

    return await request({
        method: "POST",
        // eslint-disable-next-line no-underscore-dangle
        uri: clefUrl,
        json: true,
        body: {
            "id": 1,
            "jsonrpc": "2.0",
            "method": "account_signTransaction",
            "params": [
                rawTransaction
            ]
        }
    }).then(res => {
        return res.result.raw;
    });
}

async function send() {
    // initialize contract object using the contract ABI
    const simpleStorageContract = new web3.eth.Contract(simpleStorageABI);

    // append initialization code to the simpleStorageContractBytecode - constructor argument with value 42
    const simpleStorageContractBytecodeWithInitParam = simpleStorageContract
        .deploy({
            data: simpleStorageContractBytecode,
            arguments: [42]
        })
        .encodeABI();

    // store the bytecode in tessera using the storeRawRequest API
    let rawTxHash = await rawTransactionManager.storeRawRequest(simpleStorageContractBytecodeWithInitParam, TM1_PUBLIC_KEY);

    // find the account nonce
    let acctNonce = await web3.eth.getTransactionCount(accAddress);
    console.log("account: " + accAddress + " nonce: " + acctNonce);

    // build the raw transaction
    const txnParams = {
        gasPrice: 0,
        gasLimit: 4300000,
        nonce: acctNonce,
        to: "",
        value: 0,
        data: rawTxHash
    };

    // sign the transaction
    const signedTx = await signTransaction(txnParams);

    // set the private flag for the signed transaction
    const privateSignedTx = rawTransactionManager.setPrivate(signedTx);
    const privateSignedTxHex = `0x${privateSignedTx.toString("hex")}`;

    rawTransactionManager
        .sendRawRequest(privateSignedTxHex, [
            TM7_PUBLIC_KEY
        ])
        .then(console.log)
        .catch(console.log);
}


send();
