#!/usr/bin/env bash
DDIR=$1
publicKeyName=$2
identityKeyName=$3

identityPublicKey=$(cat ${DDIR}/$publicKeyName.pub)
identityKey=$(cat ${DDIR}/$identityKeyName.sl.pub)

timestamp=$(date +%s000)
echo timestamp: $timestamp
timestampHex=$(printf "%016x" $timestamp)

base64 -d ${DDIR}/$publicKeyName.pub > ${DDIR}/dataToSign.bin
echo $timestampHex | xxd -r -p >> $DDIR/dataToSign.bin

openssl dgst -sha256 -sign $DDIR/$identityKeyName.pem -out $DDIR/signedData.bin $DDIR/dataToSign.bin

base64Signature=$(base64 $DDIR/signedData.bin | awk 'NF {sub(/\r/, ""); printf "%s",$0;}')

cat <<EOF > ${DDIR}/keyIdentities.json
[
    {
        "publicKey": "$identityPublicKey",
        "identityKey" : "$identityKey",
        "identityKeySignatureTimestamp": $timestamp,
        "identityKeySignature": "$base64Signature"
    }
]
EOF