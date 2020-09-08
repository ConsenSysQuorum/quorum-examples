**Useful commands**

* How to get a root shell into your docker host VM when running on mac:
https://gist.github.com/BretFisher/5e1a0c7bcca4c735e716abf62afad389

* enable forwarding between the 172.16.238.0/24 and 172.16.239.0/24 networks (this needs to happen on the docker host). You need to run this everytime you start your docker compose (and make sure to remove them after you bring it down).
```
iptables -I FORWARD -s 172.16.238.0/24 -d 172.16.239.0/24 -j ACCEPT
iptables -I FORWARD -d 172.16.238.0/24 -s 172.16.239.0/24 -j ACCEPT
```
* disable forwarding
```
iptables -D FORWARD -s 172.16.238.0/24 -d 172.16.239.0/24 -j ACCEPT
iptables -D FORWARD -d 172.16.238.0/24 -s 172.16.239.0/24 -j ACCEPT
```