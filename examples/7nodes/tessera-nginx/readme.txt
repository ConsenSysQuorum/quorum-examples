#the startT4HA.sh needs to be copied in the parent folder and executed from there

#command to start nginx with the specified config file
nginx -c t7.nginx -p /Users/nicolae/Develop/new-quorum-examples/quorum-examples/examples/7nodes/tessera-nginx

#to stop nginx
nginx -s stop

#details about the upstream and "backup" designation.
http://nginx.org/en/docs/http/ngx_http_upstream_module.html

#command to get the partyinfo on the tessera nodes
curl -XGET http://localhost:19004/partyinfo
curl -XGET http://localhost:29004/partyinfo