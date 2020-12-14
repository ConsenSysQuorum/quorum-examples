#!/bin/bash

set -e

pushd /tmp/run-local/ > /dev/null

export JPM_K1=$(cat tmkeys/JPM_K1 | jq -r ".publicKey | @uri")
export JPM_K2=$(cat tmkeys/JPM_K2 | jq -r ".publicKey | @uri")
export GS_K1=$(cat tmkeys/GS_K1 | jq -r ".publicKey | @uri")
export GS_K2=$(cat tmkeys/GS_K2 | jq -r ".publicKey | @uri")
export GS_K3=$(cat tmkeys/GS_K3 | jq -r ".publicKey | @uri")
export DB_K1=$(cat tmkeys/DB_K1 | jq -r ".publicKey | @uri")


###########################################################
#### JPM_Investment                                       #
###########################################################

echo "Create JPM_Investment with credentials foofoo and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/JPM_Investment
export JPM_INVESTMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/_/contracts?owned.eoa=0x0&party.tm=${JPM_K1}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"JPM_Investment\",\"client_secret\":\"foofoo\",\"scope\":\"${JPM_INVESTMENT_SCOPE}\"}" | jq .

echo "Requesting token for JPM_Investment"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=JPM_Investment" -F "client_secret=foofoo" \
  -F "scope=${JPM_INVESTMENT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token | jq .

###########################################################
#### JPM_Settlement                                       #
###########################################################

echo "Create JPM_Settlement with credentials foofoo and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/JPM_Settlement
export JPM_SETTLEMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/_/contracts?owned.eoa=0x0&party.tm=${JPM_K2}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"JPM_Settlement\",\"client_secret\":\"foofoo\",\"scope\":\"${JPM_SETTLEMENT_SCOPE}\"}" | jq .

echo "Requesting token for JPM_Investment"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=JPM_Settlement" -F "client_secret=foofoo" \
  -F "scope=${JPM_SETTLEMENT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token | jq .

###########################################################
#### JPM_Audit                                            #
###########################################################

echo "Create JPM_Audit with credentials foofoo and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/JPM_Audit
export JPM_AUDIT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/read/contracts?owned.eoa=0x0&party.tm=${JPM_K1} private://0x0/read/contracts?owned.eoa=0x0&party.tm=${JPM_K2}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"JPM_Audit\",\"client_secret\":\"foofoo\",\"scope\":\"${JPM_AUDIT_SCOPE}\"}" | jq .

echo "Requesting token for JPM_Audit"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=JPM_Audit" -F "client_secret=foofoo" \
  -F "scope=${JPM_AUDIT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token | jq .


###########################################################
#### GS_Investment                                        #
###########################################################

echo "Create GS_Investment with credentials barbar and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Research
export GS_INVESTMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/_/contracts?owned.eoa=0x0&party.tm=${GS_K1}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"GS_Investment\",\"client_secret\":\"barbar\",\"scope\":\"${GS_INVESTMENT_SCOPE}\"}" | jq .

echo "Requesting token for GS_Investment"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Investment" -F "client_secret=barbar" \
  -F "scope=${GS_INVESTMENT_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token | jq .


###########################################################
#### GS_Research                                          #
###########################################################

echo "Create GS_Research with credentials barbar and grant access to Node1"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Research
export GS_RESEARCH_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/_/contracts?owned.eoa=0x0&party.tm=${GS_K3}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\"],\"client_id\":\"GS_Research\",\"client_secret\":\"barbar\",\"scope\":\"${GS_RESEARCH_SCOPE}\"}" | jq .

echo "Requesting token for GS_Research"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Research" -F "client_secret=barbar" \
  -F "scope=${GS_RESEARCH_SCOPE}" -F "audience=Node1" https://localhost:4444/oauth2/token | jq .


###########################################################
#### GS_Settlement                                        #
###########################################################

echo "Create GS_Settlement with credentials barbar and grant access to Node2"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Settlement
export GS_SETTLEMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/_/contracts?owned.eoa=0x0&party.tm=${GS_K2}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node2\"],\"client_id\":\"GS_Settlement\",\"client_secret\":\"barbar\",\"scope\":\"${GS_SETTLEMENT_SCOPE}\"}" | jq .

echo "Requesting token for GS_Settlement"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Settlement" -F "client_secret=barbar" \
  -F "scope=${GS_SETTLEMENT_SCOPE}" -F "audience=Node2" https://localhost:4444/oauth2/token | jq .

###########################################################
#### GS_Audit                                             #
###########################################################

echo "Create GS_Audit with credentials barbar and grant access to Node1 and Node2"
curl -k -q -X DELETE https://localhost:4445/clients/GS_Audit
export GS_AUDIT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/read/contracts?owned.eoa=0x0&party.tm=${GS_K1} private://0x0/read/contracts?owned.eoa=0x0&party.tm=${GS_K2} private://0x0/read/contracts?owned.eoa=0x0&party.tm=${GS_K3}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node1\",\"Node2\"],\"client_id\":\"GS_Audit\",\"client_secret\":\"barbar\",\"scope\":\"${GS_AUDIT_SCOPE}\"}" | jq .

echo "Requesting token for GS_Audit"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=GS_Audit" -F "client_secret=barbar" \
  -F "scope=${GS_AUDIT_SCOPE}" -F "audience=Node1 Node2" https://localhost:4444/oauth2/token | jq .


###########################################################
#### DB_Investment                                        #
###########################################################

echo "Create GS_Investment with credentials barbar and grant access to Node2"
curl -k -q -X DELETE https://localhost:4445/clients/DB_Investment
export DB_INVESTMENT_SCOPE="rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x0/_/contracts?owned.eoa=0x0&party.tm=${DB_K1}"
curl -k -s -X POST https://localhost:4445/clients \
    -H "Content-Type: application/json" \
    --data "{\"grant_types\":[\"client_credentials\"],\"token_endpoint_auth_method\":\"client_secret_post\",\"audience\":[\"Node2\"],\"client_id\":\"DB_Investment\",\"client_secret\":\"barbar\",\"scope\":\"${DB_INVESTMENT_SCOPE}\"}" | jq .

echo "Requesting token for DB_Investment"
curl -k -s -X POST -F "grant_type=client_credentials" -F "client_id=DB_Investment" -F "client_secret=barbar" \
  -F "scope=${DB_INVESTMENT_SCOPE}" -F "audience=Node2" https://localhost:4444/oauth2/token | jq .


echo "To connect using any of the generated tokens please use:"
echo "geth attach https://localhost:22000 --rpcclitls.insecureskipverify --rpcclitoken \"bearer <access_token>\""

popd > /dev/null
