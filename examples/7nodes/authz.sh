#!/bin/bash

function generateAttachScript() {
    entity=$1
    auth=$2
    port=$3
    scope=$4
    ethAccts=$5
    tmKeys=$6

    auth_token=$(echo ${auth} | jq -r ".access_token")

    echo -e "#!/bin/bash\ngeth --preload $(pwd)/attach${entity}.js attach https://localhost:${port} --rpcclitls.insecureskipverify --rpcclitoken \"bearer ${auth_token}\"" > attach${entity}.sh
    chmod +x attach${entity}.sh

    cat <<EOF > $(pwd)/attach${entity}.js
info = {
    "name":"${entity}",
    "scope": "${scope}",
    "ethAccts": [${ethAccts}],
    "tmKeys": [${tmKeys}],
}
EOF
}

set -e

pushd /tmp/run-local/ > /dev/null



export JPM_K1=$(cat tmkeys/JPM_K1 | jq -r ".publicKey | @uri")
export JPM_K1_RAW=$(cat tmkeys/JPM_K1 | jq -r ".publicKey")
export JPM_K2=$(cat tmkeys/JPM_K2 | jq -r ".publicKey | @uri")
export JPM_K2_RAW=$(cat tmkeys/JPM_K2 | jq -r ".publicKey")
export GS_K1=$(cat tmkeys/GS_K1 | jq -r ".publicKey | @uri")
export GS_K1_RAW=$(cat tmkeys/GS_K1 | jq -r ".publicKey")
export GS_K2=$(cat tmkeys/GS_K2 | jq -r ".publicKey | @uri")
export GS_K2_RAW=$(cat tmkeys/GS_K2 | jq -r ".publicKey")
export GS_K3=$(cat tmkeys/GS_K3 | jq -r ".publicKey | @uri")
export GS_K3_RAW=$(cat tmkeys/GS_K3 | jq -r ".publicKey")
export DB_K1=$(cat tmkeys/DB_K1 | jq -r ".publicKey | @uri")
export DB_K1_RAW=$(cat tmkeys/DB_K1 | jq -r ".publicKey")

JPM_ACC1=$(grep JPM_ACC1 application-run-local.yml | cut -d \" -f 2)
JPM_ACC2=$(grep JPM_ACC2 application-run-local.yml | cut -d \" -f 2)
GS_ACC1=$(grep GS_ACC1 application-run-local.yml | cut -d \" -f 2)
GS_ACC2=$(grep GS_ACC2 application-run-local.yml | cut -d \" -f 2)
GS_ACC3=$(grep GS_ACC3 application-run-local.yml | cut -d \" -f 2)
DB_ACC1=$(grep DB_ACC1 application-run-local.yml | cut -d \" -f 2)

###########################################################
#### JPM_Investment                                       #
###########################################################

echo "Create JPM_Investment with credentials foofoo and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/JPM_Investment
export JPM_INVESTMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://${JPM_ACC1}/_/contracts?owned.eoa=0x0&from.tm=${JPM_K1}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"JPM_Investment\",\"client_secret\":\"foofoo\",\"scope\":\"${JPM_INVESTMENT_SCOPE}\"}" | jq .

echo "Requesting token for JPM_Investment"
JPM_INVESTMENT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=JPM_Investment" -F "client_secret=foofoo" \
  -F "scope=${JPM_INVESTMENT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token)

echo $JPM_INVESTMENT_AUTH | jq .

generateAttachScript "JPM_Investment" "${JPM_INVESTMENT_AUTH}" "22000" "${JPM_INVESTMENT_SCOPE}" "\"${JPM_ACC1}\"" "\"${JPM_K1_RAW}\""

###########################################################
#### JPM_Settlement                                       #
###########################################################

echo "Create JPM_Settlement with credentials foofoo and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/JPM_Settlement
export JPM_SETTLEMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://${JPM_ACC2}/_/contracts?owned.eoa=0x0&from.tm=${JPM_K2}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"JPM_Settlement\",\"client_secret\":\"foofoo\",\"scope\":\"${JPM_SETTLEMENT_SCOPE}\"}" | jq .

echo "Requesting token for JPM_Settlement"
JPM_SETTLEMENT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=JPM_Settlement" -F "client_secret=foofoo" \
  -F "scope=${JPM_SETTLEMENT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token)

echo $JPM_SETTLEMENT_AUTH | jq .

generateAttachScript "JPM_Settlement" "${JPM_SETTLEMENT_AUTH}" "22000" "${JPM_SETTLEMENT_SCOPE}" "\"${JPM_ACC2}\"" "\"${JPM_K2_RAW}\""

###########################################################
#### JPM_Audit                                            #
###########################################################

echo "Create JPM_Audit with credentials foofoo and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/JPM_Audit
export JPM_AUDIT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/read/contracts?owned.eoa=0x0&from.tm=${JPM_K1} private://0x0/read/contracts?owned.eoa=0x0&from.tm=${JPM_K2}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"JPM_Audit\",\"client_secret\":\"foofoo\",\"scope\":\"${JPM_AUDIT_SCOPE}\"}" | jq .

echo "Requesting token for JPM_Audit"
JPM_AUDIT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=JPM_Audit" -F "client_secret=foofoo" \
  -F "scope=${JPM_AUDIT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token)

echo $JPM_AUDIT_AUTH | jq .

generateAttachScript "JPM_Audit" "${JPM_AUDIT_AUTH}" "22000"  "${JPM_AUDIT_SCOPE}" "\"0x0\"" "\"${JPM_K1_RAW}\",\"${JPM_K2_RAW}\""

###########################################################
#### GS_Investment                                        #
###########################################################

echo "Create GS_Investment with credentials barbar and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Investment
export GS_INVESTMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://${GS_ACC1}/_/contracts?owned.eoa=0x0&from.tm=${GS_K1}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"GS_Investment\",\"client_secret\":\"barbar\",\"scope\":\"${GS_INVESTMENT_SCOPE}\"}" | jq .

echo "Requesting token for GS_Investment"
GS_INVESTMENT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Investment" -F "client_secret=barbar" \
  -F "scope=${GS_INVESTMENT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token)

echo $GS_INVESTMENT_AUTH | jq .

generateAttachScript "GS_Investment" "${GS_INVESTMENT_AUTH}" "22000" "${GS_INVESTMENT_SCOPE}" "\"${GS_ACC1}\"" "\"${GS_K1_RAW}\""

###########################################################
#### GS_Research                                          #
###########################################################

echo "Create GS_Research with credentials barbar and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Research
export GS_RESEARCH_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://${GS_ACC3}/_/contracts?owned.eoa=0x0&from.tm=${GS_K3}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"GS_Research\",\"client_secret\":\"barbar\",\"scope\":\"${GS_RESEARCH_SCOPE}\"}" | jq .

echo "Requesting token for GS_Research"
GS_RESEARCH_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Research" -F "client_secret=barbar" \
  -F "scope=${GS_RESEARCH_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token)

echo $GS_RESEARCH_AUTH | jq .

generateAttachScript "GS_Research" "${GS_RESEARCH_AUTH}" "22000" "${GS_RESEARCH_SCOPE}" "\"${GS_ACC3}\"" "\"${GS_K3_RAW}\""

###########################################################
#### GS_Settlement                                        #
###########################################################

echo "Create GS_Settlement with credentials barbar and grant access to Node2"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Settlement
export GS_SETTLEMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://${GS_ACC2}/_/contracts?owned.eoa=0x0&from.tm=${GS_K2}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node2\"],\"client_id\":\"GS_Settlement\",\"client_secret\":\"barbar\",\"scope\":\"${GS_SETTLEMENT_SCOPE}\"}" | jq .

echo "Requesting token for GS_Settlement"
GS_SETTLEMENT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Settlement" -F "client_secret=barbar" \
  -F "scope=${GS_SETTLEMENT_SCOPE}" -F "audience=Node2" https://localhost:4444/oauth2/token)

echo $GS_SETTLEMENT_AUTH | jq .

generateAttachScript "GS_Settlement" "${GS_SETTLEMENT_AUTH}" "22001" "${GS_SETTLEMENT_SCOPE}" "\"${GS_ACC2}\"" "\"${GS_K2_RAW}\""

###########################################################
#### GS_Audit                                             #
###########################################################

echo "Create GS_Audit with credentials barbar and grant access to Node1 and Node2"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Audit
export GS_AUDIT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/read/contracts?owned.eoa=0x0&from.tm=${GS_K1} private://0x0/read/contracts?owned.eoa=0x0&from.tm=${GS_K2} private://0x0/read/contracts?owned.eoa=0x0&from.tm=${GS_K3}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\",\"Node2\"],\"client_id\":\"GS_Audit\",\"client_secret\":\"barbar\",\"scope\":\"${GS_AUDIT_SCOPE}\"}" | jq .

echo "Requesting token for GS_Audit"
GS_AUDIT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Audit" -F "client_secret=barbar" \
  -F "scope=${GS_AUDIT_SCOPE}" -F "audience=Node1 Node2" https://localhost:4444/oauth2/token)

echo $GS_AUDIT_AUTH | jq .

generateAttachScript "GS_Audit" "${GS_AUDIT_AUTH}" "22001" "${GS_AUDIT_SCOPE}" "\"0x0\"" "\"${GS_K1_RAW}\",\"${GS_K2_RAW}\",\"${GS_K3_RAW}\""

###########################################################
#### DB_Investment                                        #
###########################################################

echo "Create DB_Investment with credentials barbar and grant access to Node2"
curl -k -q -X DELETE https://localhost:4445/clients/DB_Investment
export DB_INVESTMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://${DB_ACC1}/_/contracts?owned.eoa=0x0&from.tm=${DB_K1}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node2\"],\"client_id\":\"DB_Investment\",\"client_secret\":\"barbar\",\"scope\":\"${DB_INVESTMENT_SCOPE}\"}" | jq .

echo "Requesting token for DB_Investment"
DB_INVESTMENT_AUTH=$(curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=DB_Investment" -F "client_secret=barbar" \
  -F "scope=${DB_INVESTMENT_SCOPE}" -F "audience=Node2" https://localhost:4444/oauth2/token)

echo $DB_INVESTMENT_AUTH | jq .

generateAttachScript "DB_Investment" "${DB_INVESTMENT_AUTH}" "22001" "${DB_INVESTMENT_SCOPE}" "\"${DB_ACC1}\"" "\"${DB_K1_RAW}\""


echo "To connect using any of the generated tokens please use:"
echo "geth attach https://localhost:22000 --rpcclitls.insecureskipverify --rpcclitoken \"bearer <access_token>\""
echo
echo "Alternatively use one of the generated attach<entity>.sh scripts. Ex: /tmp/run-local/attachGS_Investment.sh."
echo "If unsure what you are connected to just type info in the console and tenant details should be displayed."

popd > /dev/null
