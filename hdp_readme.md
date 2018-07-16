# HDP Issues/Adjustments in the Docker environment

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
