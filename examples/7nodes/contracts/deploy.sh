#!/usr/bin/env bash

#run the solc commands first
roles="NONE"
voter="NONE"
accounts="NONE"
nodes="NONE"
org="NONE"
custodian="0xed9d02e382b34818e88b88a309c7fe71e65f419d"
permImpl="NONE"
permInterface="NONE"
upgr="NONE"


updateLoadScript(){
    file=$1
    varName=$2
    contAddr=$3
    echo -e "var $varName = web3.eth.contract(abi).at(\"$contAddr\");">> ../JS/$file
}
deployContract(){
    file=$1
    name=$2
    op=`./runscript.sh ../JS/$file`
    tx=`echo $op | head -1 | tr -s " "| cut -f5 -d " "`
    contAddr=`./get-contract-address.sh $tx`
    if [ "$name" == "r" ]
    then
        echo "Role Manager is - $contAddr"
        roles=$contAddr
        updateLoadScript "load-RoleManager.js" $name $contAddr
    elif [ "$name" == "a" ]
    then
        echo "Account Manager is - $contAddr"
        accounts=$contAddr
        updateLoadScript "load-AccountManager.js" $name $contAddr
    elif [ "$name" == "v" ]
    then
        echo "Voter Manager is - $contAddr"
        voter=$contAddr
        updateLoadScript "load-VoterManager.js" $name $contAddr
    elif [ "$name" == "n" ]
    then
        echo "Node Manager is - $contAddr"
        nodes=$contAddr
        updateLoadScript "load-NodeManager.js" $name $contAddr
    elif [ "$name" == "o" ]
    then
        echo "Org Manager is - $contAddr"
        org=$contAddr
        updateLoadScript "load-OrgManager.js" $name $contAddr
    elif [ "$name" == "impl" ]
    then
        echo "Permissions implementations is - $contAddr"
        permImpl=$contAddr
        updateLoadScript "load-PermissionsImplementation.js" $name $contAddr
    elif [ "$name" == "intr" ]
    then
        echo "Permissions interface is - $contAddr"
        permInterface=$contAddr
        updateLoadScript "load-PermissionsInterface.js" $name $contAddr
    elif [ "$name" == "upgr" ]
    then
        echo "Permissions upgradable is - $contAddr"
        upgr=$contAddr
        updateLoadScript "load-PermissionsUpgradable.js" $name $contAddr
    fi
}
# first deploy upgradable and then rest
./cref.sh PermissionsUpgradable $upgr
deployContract "deploy-PermissionsUpgradable.js" "upgr"
#deploy others
./cref.sh OrgManager $upgr
./cref.sh RoleManager $upgr
./cref.sh NodeManager $upgr
./cref.sh VoterManager $upgr
./cref.sh AccountManager $upgr
./cref.sh PermissionsImplementation $upgr
./cref.sh PermissionsInterface $upgr


deployContract "deploy-RoleManager.js" "r"
deployContract "deploy-AccountManager.js" "a"
deployContract "deploy-VoterManager.js" "v"
deployContract "deploy-NodeManager.js" "n"
deployContract "deploy-OrgManager.js" "o"
deployContract "deploy-PermissionsImplementation.js" "impl"
deployContract "deploy-PermissionsInterface.js" "intr"


echo -e "var rc = \"$roles\"" >>../JS/load-PermissionsInterface.js
echo -e "var ac = \"$accounts\"">>../JS/load-PermissionsInterface.js
echo -e "var vc = \"$voter\"">>../JS/load-PermissionsInterface.js
echo -e "var nc = \"$nodes\"">>../JS/load-PermissionsInterface.js
echo -e "var oc = \"$org\"">>../JS/load-PermissionsInterface.js
echo -e "var impl = \"$permImpl\"">>../JS/load-PermissionsUpgradable.js
echo -e "var intr = \"$permInterface\"">>../JS/load-PermissionsUpgradable.js
echo -e "var up = \"$upgr\"">>../JS/load-PermissionsUpgradable.js