# Run the ../kubernetes/install_k8s.yaml playbook across the cluster first.

# Initialize Docker Swarm
ansible os01 -b -a 'docker swarm init --advertise-addr 10.0.1.11 --listen-addr 10.0.1.11'
ansible os01 -b -a 'docker info'
SWARM_JOIN=`ansible os01 -b -a 'docker swarm join-token worker' | grep docker`

# Trying to add: --advertise-addr eno1 --listen-addr eno1 to above..
# Example:
# This assumes our network interface is eno1 !!!
# docker swarm join --advertise-addr eno1 --listen-addr eno1 --token SWMTKN-1-5hv1a7xzv1jmvlnqy1e8s11fkw3xwndyrve7yw288t19ql30jm-3b7m6ydohjzge5u6xcu836reo 10.0.1.11:2377
NEW_JOIN=`echo "${SWARM_JOIN}" | sed s/"join --token"/"join --advertise-addr eno1 --listen-addr eno1"/g`

echo "SWARM_JOIN=${NEW_JOIN}"

# Have the other docker nodes join the swarm
ansible hdp -b -a "${NEW_JOIN}"

# Validate the SWARM
ansible os01 -b -a 'docker node ls'

# Create the core network (Docker recommends only setting up /24 networks)
ansible os01 -b -a 'docker network create --driver=overlay --gateway 192.168.44.1 --subnet 192.168.44.1/24 --attachable home'

# Create the base directories to devices to be used in cluster.
ansible os -b -a 'mkdir -p /data'
