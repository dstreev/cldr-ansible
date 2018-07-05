# These configs are the drivers for the process to create a cluster.

The filename (minus extension) represents the Environment Instance that the config will create when the `../bin/01_launch.sh -i <env_instance>` is run.

## volumes

Each container attaches to a few volumes.  These are persisted across restarts.  They contain data for the cluster.  So if you kill an instance, the volumes should persist (unless you purge them with `docker volume prune -f` on the docker host).

Each cluster instance also uses a central db.  Each schema has an environment postfix too.

So, we need to establish a range of configs for each Ambari / HDFS version.  This will help with rehydrating a cluster is we remove the stack.

# Config Guidelines

## Legend
**STACK** / Section | Ambari | Masters | Workers | DB | Repo
--|---|---|---|---|--
**INFRA** | na | na | na | db.hwx (on os01) | repo.hwx (on os04)
full  | ambari-${ENV_INSTANCE}.hwx (on os01)  | os[02-07].hwx | os[10-19]-${ENV_INSTANCE}.hwx  | db.hwx  | repo.hwx
left  | ambari-${ENV_INSTANCE}.hwx (on os01)  | os[02-04].hwx | os[10-13]-${ENV_INSTANCE}.hwx  | db.hwx  | repo.hwx
right  | ambari-${ENV_INSTANCE}.hwx (on os01)  | os[05-07].hwx | os[15-19]-${ENV_INSTANCE}.hwx  | db.hwx  | repo.hwx

Environment  | Location  | Ambari Version  | HDP Version | Date Added | Notes
--|---|---|---|---|--
*10* | center | [2.6.2.2](http://ambari-10.hwx:8080) | 2.6.5.0 | 2018-07-05 | Kafka Cluster
[Portainer](http://os01.streever.local:9000)  |   |   |   |   |
*11* | right |  [2.6.2.2](http://ambari-11.hwx:8080) | 2.6.5.0 | 2018-07-04 | Basic HDP (HA, Ranger, Knox)
*12* | left  | [2.6.2.2](http://ambari-12.hwx:8080) | 2.6.5.0 | 2018-07-04 | Basic HDP (HA, Ranger, Knox)
