# HDP Issues/Adjustments in the Docker environment

## Networking

Networking in a container environment can be challenging.  Not because of the setup, but because of all the scenario's you'll find with cross component communications in a HDP environment.

Challenges include:
- reverse DNS
- Hostnames
- Service Proxies (Docker Services)

I've tried to deploy my clusters by individually deploying containers on the same 'swarm' overlay network so they could talk to each other across hosts.  This seemed to work, for a bit, but the DNS entries in Docker's overlay network get confused if you start/stop a container.  Simple 'ping' tests between nodes show how they all can't reach each other.

So the method that's gotten me a bit further is using 'docker stacks' via a compose file.  But again, the networking starts to mess with the cluster.

I create the overlay network separately so I can have each 'cluster' use the same network and see each other, if needed.  So the compose file references the overlay network as 'external'.

The 'deploy' section for a service in the compose file allows you to switch how the service will be created in the swarm.  In my case, I needed each host to be independent.  One container per service, one container per HDP host.

[`.service.deploy`](https://docs.docker.com/compose/compose-file/#deploy) in the compose file for the service has the following options I explored.
`.service.deploy.mode` has two settings: global or replicated.
- global will create the service on ever docker host.
- replicated will create the number of containers specified by `replicas`

I only wanted one container per service, so I use `.service.deploy.placement.constraints` and docker node labels to restrict the placement.  It seems that `global` and `replicated` with `replicas: 1`, combined with labels to control placement both did the trick.

`.service.deploy.endpoint_mode` controls how the DNS entries are projected for the service.  When set to `vip`, HDFS won't work.  It will come up...  The Datanodes can't find the Namenode and the Namenode reports '0' Live Nodes, even when each Datanode has started.  He's the error seen in the Datanode logs.

```
2018-08-07 19:42:30,259 ERROR datanode.DataNode (BPServiceActor.java:run(823)) - Initialization failed for Block pool BP-908800627-192.168.100.75-1533669323500 (Datanode Uuid 3ea4cd04-26b0-48a5-8d84-1207b5f744cf) service to os02-15.hwx/192.168.100.74:8020 Datanode denied communication with namenode because hostname cannot be resolved (ip=192.168.100.6, hostname=192.168.100.6): DatanodeRegistration(0.0.0.0:50010, datanodeUuid=3ea4cd04-26b0-48a5-8d84-1207b5f744cf, infoPort=50075, infoSecurePort=0, ipcPort=8
```

Here's a ping from one node to another.
```
[root@os04-15 ~]# ping os03-15.hwx
PING os03-15.hwx (192.168.100.76) 56(84) bytes of data.
64 bytes from 192.168.100.76 (192.168.100.76): icmp_seq=1 ttl=64 time=0.204 ms
```
Notice how there is no hostname resolution. And here's the `ip addr` of the pinged host.

```
[root@os03-15 ~]# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
130: eth0@if131: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default
    link/ether 02:42:c0:a8:64:4d brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.77/22 brd 192.168.103.255 scope global eth0
       valid_lft forever preferred_lft forever
```
The ip's don't match.  Why?  That's because the ip returned in the ping is a 'vip'.

It's important to note here that the network resolves a 'service' and not a 'container'.  That's why there is a 'service' for each node in my HDP cluster.



## General

### nofile limits

The docker hosts can't support (under the default config) high ulimits.  An HDP deployment will default to `128000` for some components.  This needs to be adjusted for some services to start correctly.

#### Symptom
A service fails to start, reporting an issue with 'su' and 'permissions'.

#### Fix
For HDFS and KAFKA, adjust the 'nofile' limit to `65356` (from `128000`) and restart the service.

hdfs:
`hdfs_user_nofile_limit=65536`

kafka:
`kafka_user_nofile_limit=65536`

infra_solr:
`infra_solr_user_nofile_limit=65536`

storm:
`storm_user_nofile_limit=65536`

## YARN

Docker Issues with YARN DNS Registry.

```
hadoop.registry.dns.enabled=true
# Increase port to non root port, to avoid needing host to be 'privileged'
registry.dns.bind-port=1053

```

## HBase

### Host Identification issues

In the docker environment, hostnames and resolution is done at the 'service' level.  HDP is not a service, under traditional micro-service conventions.  We need to force hbase to use a specific interface port for it to work correctly.

#### Symptom

HBase will initialize but will not pass a service check.  The error message will be `ERROR: Can't get the location for replica 0`.  When you visit the HBase Master UI, you'll see 2-3x the number of Region Servers you have and none will report a version.

#### Fix

Add the following configuration for HBase to hbase-site.xml and restart:
```
hbase.master.dns.interface=eth0
hbase.regionserver.dns.interface=eth0
```
This will force HBase to use a specific host interface when reporting.

Note: These settings aren't specifically set in Ambari already AND these are the default settings in hbase-default.xml.  But the 'eth0' doesn't appear to be used specifically for some reason.  Hence, this override is necessary.

## Hive

### Network Reverse Lookup Issue when Starting LLAP

#### Symptom

```
WARN conf.HiveConf: HiveConf of name hive.heapsize does not exist
WARN conf.HiveConf: HiveConf of name hive.druid.select.distribute does not exist
ERROR utils.MetaStoreUtils: Got exception: java.net.URISyntaxException Illegal character in hostname at index 14: thrift://hdp16_os04.1.5uo9nia7pfgqfimrub1nnq8qw.hdp_base:9083
java.net.URISyntaxException: Illegal character in hostname at index 14: thrift://hdp16_os04.1.5uo9nia7pfgqfimrub1nnq8qw.hdp_base:9083
	at java.net.URI$Parser.fail(URI.java:2848) ~[?:1.8.0_171]
	at java.net.URI$Parser.parseHostname(URI.java:3387) ~[?:1.8.0_171]
	at java.net.URI$Parser.parseServer(URI.java:3236) ~[?:1.8.0_171]
```
