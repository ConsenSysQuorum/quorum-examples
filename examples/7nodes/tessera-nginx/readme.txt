#the startT4HA.sh needs to be copied in the parent folder and executed from there

#the tessera configs must be copied (and paths updated) to the qdata/c4 directory
#both tessera nodes use the same H2 DB - AUTO_SERVER=TRUE (first node to start actually hosts the DB while the other connects to it via localhost)

#command to start nginx with the specified config file
nginx -c t7.nginx -p /Users/nicolae/Develop/new-quorum-examples/quorum-examples/examples/7nodes/tessera-nginx

#to stop nginx
nginx -s stop

#details about the upstream and "backup" designation.
http://nginx.org/en/docs/http/ngx_http_upstream_module.html

#command to get the partyinfo on the tessera nodes
curl -XGET http://localhost:19004/partyinfo
curl -XGET http://localhost:29004/partyinfo



#for the Quorum HA please use the following scripts (you may need to edit some paths in the corresponding configs to match your environment):
./raft-init-Node4HA.sh
./raft-start-Node4HA.sh tesseara

#the above should initialize the quorum/tessera nodes. Instead of a single dd4 directory you will get
qdata/d41
qdata/d42
#each has a separate nodekey (nodekey4 and nodekey8 from the raft folder), but they share the same ethereum
#account key (used for signing transactions)

#Once started the two quorum nodes talk to the same tessera process (from qdata/c4). The init process also copies the
#two tessera HA config files into the qdata/c4 directory but tessera is not started in HA by default.

#the following extra nginx configs are provided:
q4.nginx - is used to loadbalance incoming RPC TCP connections on port 22003 and they are forwarded to either port 42003 or 42007 (quorum 41 or 42)
t4q4.nginx - combines tessera HA from above with Quorum HA (q4.nginx)

#you can kill the single tessera 4 process and use ./startT4HA.sh to start tessera in HA mode (if you do this use the t4q4.nginx config).
