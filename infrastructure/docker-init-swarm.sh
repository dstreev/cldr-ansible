# Run the ../kubernetes/install_k8s.yaml playbook across the cluster first.

# Initialize Docker Swarm
ansible os1 -b -a 'docker swarm init --advertise-addr 10.0.1.11 --listen-addr 10.0.1.11'
ansible os1 -b -a 'docker info'
SWARM_JOIN=`ansible os1 -b -a 'docker swarm join-token worker' | grep docker`

# Have the other docker nodes join the swarm
ansible hdp -b -a "${SWARM_JOIN}"

# Validate the SWARM
ansible os1 -b -a 'docker node ls'

# Create the core network
ansible os1 -b -a 'docker network create --driver=overlay --gateway 192.168.44.1 --subnet 192.168.44.1/22 --attachable home'

# Create the base directories to devices to be used in cluster.
ansible os -b -a 'mkdir -p /data'
