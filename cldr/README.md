# Transition Workflow

Clone Repo and chdir to base.
```
git clone <repo_url> <target_dir>
cd <target_dir>
```

Configure Alias (dislike typing)
```
alias ap=ansible-playbook
alias ape=ansible-playbook --extra-vars
alias apt=ansible-playbook --tags
```

Create and Configure an [Ansible Hosts](../config/sample_env.yaml) file for Build-out.  Either add `-i` option to every ansible call or configure ansible to automatically use the config.

## Prep
**Build Local Repo**
`ap cldr/devops/repo_sync.yaml`
Then check and unpack CM tarball

**Ensure all hosts are consistent with pre-reqs**
`ape "hosts=all" environment/baremetal/os_pre_reqs.yaml`

**Create Backups**
`ap devops/db_backup.yaml`

**Build and Deploy Tools**
__SKIP IF USING MOD'd version__
`ap cldr/tooling/am2cm_build.yaml`

**Deploy AM2CM on to an Edge Node**
`ap cldr/tooling/am2cm_install.yaml`

**Deploy the Ranger Policy Migration Tool**
`ap cldr/tooling/ranger_migration_install.yaml`

**Configure AM2CM**
`ap cldr/tooling/am2cm_configure.yaml`

## Installation
**Install Cloudera Manager**
`ap cldr/cm/cm_install.yaml`
This install CM and creates the databases for CM and Report Manager and deploys JDBC jars and MariaDB Clients where needed.

### Manual Process
- Set Networking/Repo Locations for Local Repos
- Set CM TLS
- Configure Kerberos
- Add Hosts
> Need to have all hosts added that are used in Ambari Cluster
- Add Cloudera Management Service

### Run the Transition
**NOTE: Waiting for silent mode in am2cm Tool**

`ap cldr/tooling/ambari_blueprint.yaml`

Goto edge and run:
```
cd am2cm-conversion/
../am2cm-1.0-SNAPSHOT/am2cm.sh -bp HOME90-blueprint.json  -dt HOME90-cm_template.json
```
then on the ansible host...
`apt "submit" cldr/tooling/transition.yaml`


#### Or with Silent Mode
Once the `-s` mode is available for am2cm run the entire `transition.yaml`:
`ap cldr/tooling/transition.yaml` 

## Activation

In Cloudera Manager 'Download' and 'Distribute' the Parcel. Do not 'Activate' yet.

Ensure Ambari Cluster is Health and that HDFS is in good shape:
- Save HDFS Namespace
- Ensure no underreplicated blocks
- Check the 'Exclude Hosts' list is empty. IE: No dead/inactive datanodes.

In Ambari, shutdown all Services and 'Stop' and 'Disable' all **Ambari Agents**.  The **takeover** starts NOW.

Disable Ambari Agents
`ap cldr/ambari/disable-agent.yaml`

In Cloudera Manager, 'Activate' the Parcel on all hosts.  This will reconfigure all the symlinks for the cluster configurations.

## Starting Services

### First Phase Cleanup
`ap cldr/reset/cm_reset_phase_1.yaml`
- Enable Security
  - TLS
  - Kerberos
- Start ZooKeeper
- Remove /hadoop-ha znode
- Deploy the clients
- formatZK

### Enable Security
- TLS
- Kerberos

### Add Service
Yarn Queue Manager
KNOX
Hue

### Starting Initial Core Services (optional)
HDFS

### Adding Services (Order Matters)
Solr
Atlas (will rename Solr Service to CDP-INFRA-SOLR)
Ranger

### Configure Ranger User to Allow Policy Creation

#### Didn't work.  Still investigating.
- Add / Modify `hdfs` user with 'admin' role.
> HDFS uses the `hdfs` principal to securely sign into Ranger.  It needs to be able to create a policy for the service.

### Validate / Check Safety Value Settings in:
- HDFS
- YARN
- Hive
- Hive On Tez
- Spark
- Oozie
- TEZ
- Kafka
- ZooKeeper

### Activate Ranger for Each Service
- HDFS
- YARN
- KNOX
- Atlas
- Hive
- Hive on Tez (HS2)
- Kafka

### Start/Restart Services

Restart ALL
- Hive / Hive on TEZ may fail until TEZ Libraries are distributed
`Caused by: java.io.FileNotFoundException: File does not exist: hdfs://HOME90/user/tez/0.9.1.7.1.1.0-565/tez.tar.gz`

### Migrate Ranger Policies
- HDFS
- YARN
- ...

### Adding Libraries
TEZ



## RESET (soft - don't kill)

### CM to Ambari

1. Stop ALL services in CM
2. Disable CM Agents
    `ap cldr/cm/agent_disable.yaml`
3. Enable and Configure Ambari HDP
    `ap cldr/ambari/agent_enable.yaml`
    `ap cldr/reset/hdp_service_reset.yaml`
4. Goto Ambari and Start Services    

### Ambari to CM

1. Stop ALL services in Ambari
2. Disable Ambari Agents
    `ap cldr/ambari/agent_disable.yaml`
3. Enable and Configure CM
    `ap cldr/cm/agent_enable.yaml`
    ? ...

## RESET (HARD - Kill Environment)

### CM

1. Stop all components in CM
2. Turn off, disable, and remove CM
    `ap cldr/cm/cm_remove.yaml`




