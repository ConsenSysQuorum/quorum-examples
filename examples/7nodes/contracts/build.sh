#!/usr/bin/env bash

contract=$1
data=$2
cd /Users/saiv/work/quorum-examples/examples/7nodes/contracts

#echo "INside build.sh $1.sol $2"

#compile and generate solc output in abi
solc --bin --optimize --overwrite -o ./abi $1.sol 2>>/dev/null
solc --abi --optimize --overwrite -o ./abi $1.sol 2>>/dev/null


cd /Users/saiv/work/quorum-examples/examples/7nodes/JS

deployFile="deploy-$contract.js"
loadFile="load-$contract.js"

rm $deployFile $loadFile 2>>/dev/null

abi=`cat ../contracts/abi/$contract.abi`
bc=`cat ../contracts/abi/$contract.bin`
echo -e "ac = eth.accounts[0];" >> ./$deployFile
echo -e "web3.eth.defaultAccount = ac;" >> ./$deployFile
echo -e "var abi = $abi;">> ./$deployFile
echo -e "var bytecode = \"0x$bc\";">> ./$deployFile
echo -e "var simpleContract = web3.eth.contract(abi);">> ./$deployFile
if [ "$data" == "NONE" ]
then
    echo -e "var a = simpleContract.new(\"0xed9d02e382b34818e88b88a309c7fe71e65f419d\",{from:web3.eth.accounts[0], data: bytecode, gas: 7200000}, function(e, contract) {">> ./$deployFile
else
    echo -e "var a = simpleContract.new(\"$data\", {from:web3.eth.accounts[0], data: bytecode, gas: 7200000}, function(e, contract) {">> ./$deployFile
fi
echo -e "\tif (e) {">> ./$deployFile
echo -e "\t\tconsole.log(\"err creating contract\", e);">> ./$deployFile
echo -e "\t} else {">> ./$deployFile
echo -e "\t\tif (!contract.address) {">> ./$deployFile
echo -e "\t\t\tconsole.log(\"Contract transaction send: TransactionHash: \" + contract.transactionHash + \" waiting to be mined...\");">> ./$deployFile
echo -e "\t\t} else {">> ./$deployFile
echo -e "\t\t\tconsole.log(\"Contract mined! Address: \" + contract.address);">> ./$deployFile
echo -e "\t\t\tconsole.log(contract);">> ./$deployFile
echo -e "\t\t}">> ./$deployFile
echo -e "\t}">> ./$deployFile
echo -e "});">> ./$deployFile

name=`echo ${contract} | head -c 1 | tr '[:upper:]' '[:lower:]'`

echo -e "ac = eth.accounts[0];">> ./$loadFile
echo -e "web3.eth.defaultAccount = ac;">> ./$loadFile
echo -e "var abi = $abi;">> ./$loadFile
#echo -e "var $name = web3.eth.contract(abi).at(\"address\");">> ./$loadFile




cd /Users/saiv/work/quorum-examples/examples/7nodes/contracts
