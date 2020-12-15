# Authorization script
Use in conjunction with the `quorum-acceptance-tests` `raft-multitenant` network.

Prepare/download/tag the relevant quorum and tessera docker images then start the `raft-multitenant` network using:
```shell
mvn process-test-resources -Pauto -Dnetwork.target="networks/plugins::raft-multitenancy"
```
Run the authz.sh script. 
The attach scripts will be generated in the `/tmp/run-local` folder (adjust the script as you see fit).

Run the corresponding attach script to connect to quorum as the specific client/tenant. Ex:
```shell
/tmp/run-local/attachJPM_Investment.sh
```

Once attached you can use the `info` command to quicky see who you are connected as.
```javascript
> info
{
  ethAccts: ["0x161e01005a902d62b86b46e7ff56afff0611129b"],
  name: "GS_Research",
  scope: "rpc://eth_* rpc://quorumExtension_* rpc://rpc_modules private://0x161e01005a902d62b86b46e7ff56afff0611129b/_/contracts?owned.eoa=0x0&from.tm=o7WSnfyjclbtQkUldBQPRVVORn7OoJD0XnqwwpX%2BN24%3D",
  tmKeys: ["o7WSnfyjclbtQkUldBQPRVVORn7OoJD0XnqwwpX+N24="]
}
```
