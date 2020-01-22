#!/usr/bin/env bash
DDIR=$1
publicKeyName=$2
identityKeyName=$3

identityPublicKey=$(cat ${DDIR}/$publicKeyName.pub)
identityKey=$(cat ${DDIR}/$identityKeyName.sl.pub)

timestamp=$(date +%s%3N)
echo timestamp: $timestamp
timestampHex=$(printf "%016x" $timestamp)

base64 -d ${DDIR}/$publicKeyName.pub > ${DDIR}/dataToSign.bin
echo $timestampHex | xxd -r -p >> $DDIR/dataToSign.bin

openssl dgst -sha256 -sign $DDIR/$identityKeyName.pem -out $DDIR/signedData.bin $DDIR/dataToSign.bin

base64Signature=$(base64 -w 0 $DDIR/signedData.bin)

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