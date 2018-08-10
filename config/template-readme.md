# These configs are the drivers for the process to create a cluster.

The filename (minus extension) represents the Environment Instance that the config will create when the `../bin/01_deploy.py -i <env_instance>` is run.

## Docker Volumes

Each container attaches to a few volumes.  These are persisted across restarts.  They contain data for the cluster.  So if you kill an instance, the volumes should persist (unless you purge them with `docker volume prune -f` on the docker host).

Each cluster instance also uses a central db.  Each schema has an environment postfix tooÂ.

So, we need to establish a range of configs for each Ambari / HDFS version.  This will help with rehydrating a cluster is we remove the stack.

# Config Guidelines

## Legend
**STACK** / Section | Ambari | Masters | Workers | DB | Repo
--|---|---|---|---|--


Environment | Instance | Location  | Ambari Version  | HDP/HDF Version | Date Added | Notes
---|--|---|---|---|--
