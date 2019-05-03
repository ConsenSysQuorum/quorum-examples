#!/bin/bash
set -u
set -e

echo "[*] copying permissions config to data directories"

echo "[*] copying to  node 1 data dir"
cp permission-config.json qdata/dd1/

echo "[*] copying to  node 2 data dir"
cp permission-config.json qdata/dd2/

echo "[*] copying to  node 3 data dir"
cp permission-config.json qdata/dd3/

#echo "[*] copying to  node 4 data dir"
#cp permission-config.json qdata/dd4/

#echo "[*] copying to  node 5 data dir"
#cp permission-config.json qdata/dd5/
#
#echo "[*] copying to  node 6 data dir"
#cp permission-config.json qdata/dd6/
#
#echo "[*] copying to  node 7 data dir"
#cp permission-config.json qdata/dd7/
