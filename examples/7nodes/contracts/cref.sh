#!/usr/bin/env bash
cd ~/work/quorum-examples/examples/7nodes/contracts
#./build.sh OrgManager
#./build.sh RoleManager
#./build.sh NodeManager
#./build.sh VoterManager
#./build.sh AccountManager
#./build.sh PermissionsImplementation
#./build.sh PermissionsInterface
#./build.sh PermissionsUpgradable
fileName=$1
data=$2

./build.sh $fileName $data