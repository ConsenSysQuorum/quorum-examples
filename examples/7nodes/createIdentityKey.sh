#!/usr/bin/env bash
DDIR=$1
keyName=$2

openssl ecparam -name secp256k1 -genkey -out $DDIR/$keyName.pem
openssl ec -in $DDIR/identityKey.pem -pubout -out $DDIR/$keyName.pub

awk '!/^-----BEGIN PUBLIC KEY-----/' $DDIR/$keyName.pub | awk '!/^-----END PUBLIC KEY-----/' | awk 'NF {sub(/\r/, ""); printf "%s",$0;}' > $DDIR/$keyName.sl.pub