const rp = require("request-promise-native");
require('log-timestamp');

const simpleStorageDeploy = "6060604052341561000f57600080fd5b604051602080610149833981016040528080519060200190919050505b806000819055505b505b610104806100456000396000f30060606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680632a1afcd914605157806360fe47b11460775780636d4ce63c146097575b600080fd5b3415605b57600080fd5b606160bd565b6040518082815260200191505060405180910390f35b3415608157600080fd5b6095600480803590602001909190505060c3565b005b341560a157600080fd5b60a760ce565b6040518082815260200191505060405180910390f35b60005481565b806000819055505b50565b6000805490505b905600a165627a7a72305820d5851baab720bba574474de3d09dbeaabc674a15f4dd93b974908476542c23f00029";

const simpleStorageDeployBytes = Buffer.from(simpleStorageDeploy, "hex");


const TOTAL_TXN = 50000;
const MAX_PARALLEL = 10;

var txCount = 0;
var txParallelCount = 0;

const options = {
    method: "POST",
    headers: {
        'Content-Type': 'application/octet-stream',
        'c11n-to': 'R56gy4dn24YOjwyesTczYa8m5xhP6hF2uTMCju/1xkY=',
        'Accept': 'text/plain'
    },
    // uri: `http://unix:/home/nicolae/Develop/go/new-quorum-examples/quorum-examples/examples/7nodes/qdata/c1/tm.ipc:/sendraw`,
    uri: `http://unix:/home/nicolae/Develop/perftests/quorum-examples/examples/7nodes/qdata/c1/tm.ipc:/sendraw`,
    body: simpleStorageDeployBytes
};

//console.log(web3);

let lastTxCount = 0;
const startTs = Date.now();

function init() {
    const intervalObj = setInterval(function () {
        console.log(" txParallelCount:" + txParallelCount + " txCount:" + txCount + " delta:" + (txCount-lastTxCount));
        lastTxCount = txCount;
        if (txCount < TOTAL_TXN) {
            if (txParallelCount < MAX_PARALLEL) {
                send();
            }
        } else {
            const endTs = Date.now();
            console.log("Test finished. Average TPS=" + (TOTAL_TXN*1000)/(endTs-startTs));
            process.exit(0);
        }
    }, 1000);
}

function send() {
    if (txCount < TOTAL_TXN) {
        txCount = txCount + 1;
        txParallelCount = txParallelCount + 1;
        rp(options).then(
            function (response) {
                txParallelCount = txParallelCount - 1;
                send();
            }
        ).catch(
            function (error) {
                txParallelCount = txParallelCount - 1;
                txCount = txCount - 1;
                console.log("An error has occurred:" + error);
            }
        )
    }
}

init();
