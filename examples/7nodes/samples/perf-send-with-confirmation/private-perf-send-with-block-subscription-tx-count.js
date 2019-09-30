const Web3 = require("web3");

const wsProvider = new Web3.providers.WebsocketProvider("ws://localhost:8547", {
    headers: {
        Origin: "http://localhost"
    }
});
const web3 = new Web3(wsProvider);

const TM1_PUBLIC_KEY = "R56gy4dn24YOjwyesTczYa8m5xhP6hF2uTMCju/1xkY=";
const TM2_PUBLIC_KEY = ["BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo="];

const simpleStorageDeploy = "0x6060604052341561000f57600080fd5b604051602080610149833981016040528080519060200190919050505b806000819055505b505b610104806100456000396000f30060606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632a1afcd914605157806360fe47b11460775780636d4ce63c146097575b600080fd5b3415605b57600080fd5b606160bd565b6040518082815260200191505060405180910390f35b3415608157600080fd5b6095600480803590602001909190505060c3565b005b341560a157600080fd5b60a760ce565b6040518082815260200191505060405180910390f35b60005481565b806000819055505b50565b6000805490505b905600a165627a7a72305820d5851baab720bba574474de3d09dbeaabc674a15f4dd93b974908476542c23f00029";

const abi = [{
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

const simpleContract = new web3.eth.Contract(abi);

const initializedDeploy = simpleContract
    .deploy({
        data: simpleStorageDeploy,
        arguments: [42]
    })
    .encodeABI();

const accAddress = "0x0638e1574728b6d862dd5d3a3e0942c3be47d996";// node 5
//const accAddress = "0xed9d02e382b34818e88b88a309c7fe71e65f419d"; // node 1


const txnParams = {
    gasPrice: 0,
    gasLimit: 4300000,
    to: null,
    value: 0,
    data: initializedDeploy,
    from: accAddress,
    privateFrom: TM1_PUBLIC_KEY,
    privateFor: TM2_PUBLIC_KEY
};

const TOTAL_TXN = 50000;
const MAX_OUTSTANDING = 5000;
const MIN_OUTSTANDING = 2500;

var txCount = 0;
var outstandingTx = 0;
var successfullySentCounter = 0;

var blockSubscription = null;

var startTime = null;


function start() {
    console.log("Starting test. TotalTxToSend: " + TOTAL_TXN);
    startTime = Date.now();
    blockSubscription = web3.eth.subscribe('newBlockHeaders')
        .on("data", onNewBlock)
        .on("error", console.error);
}

function onNewBlock(blockHeader) {
    console.log("Block No: " + blockHeader.number);
    web3.eth.getBlockTransactionCount(blockHeader.hash)
        .then(function (txCountInBlock) {
            console.log("Txs in block: " + txCountInBlock);
            outstandingTx = outstandingTx - txCountInBlock;
            if (txCount < TOTAL_TXN) {
                if (outstandingTx < MIN_OUTSTANDING) {
                    send();
                }
            } else if (outstandingTx === 0) {
                blockSubscription.unsubscribe(function (error, success) {
                    if (success) {
                        console.log("Successfully unsubscribed!");
                        endTime = Date.now();
                        tps = TOTAL_TXN * 1000 / (endTime - startTime);
                        console.log("Average TPS: " + tps);
                        console.log("End txCount: " + txCount);
                        process.exit();
                    }
                })
            }
        });
}

function send() {
    toSend = MAX_OUTSTANDING;
    if (txCount + toSend > TOTAL_TXN) {
        toSend = TOTAL_TXN - txCount;
    }
    for (i = 0; i < toSend; i++) {
        web3.eth.sendTransaction(txnParams, function (error, result) {
            if (error) {
                console.log("An error occurred while trying to send a transaction.");
                txCount = txCount - 1;
                outstandingTx = outstandingTx - 1;
            }
            successfullySentCounter = successfullySentCounter + 1;
            if (successfullySentCounter % 500 === 0) {
                console.log("successfullySentCounter: " + successfullySentCounter);
            }
        });
    }
    txCount = txCount + toSend;
    outstandingTx = outstandingTx + toSend;
}

start();