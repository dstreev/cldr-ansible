# ansible-playground

## Installation an HDP Cluster

### Bare Metal Steps (one time)
- Step 1:
  - Install [Docker and K8s on target hosts](./kubernetes/install_k8s.yaml)
- Step 2:
  - [Create Swarm Network for Docker](./infrastructure/docker-init-swarm.sh)

### Initialize / Start Init Containers

You need to do this for the 'core' network to show up on slave swarm nodes.

[Initialize](./infrastructure/core-init.sh)

#### Required after restart of Docker or Hosts
[Start](./infrastructure/core-start.sh)
