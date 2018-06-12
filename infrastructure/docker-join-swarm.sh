# Run the ../kubernetes/install_k8s.yaml playbook across the cluster first.

ansible os01 -b -a 'docker info'
SWARM_JOIN=`ansible os01 -b -a 'docker swarm join-token worker' | grep docker`

# docker swarm join --advertise-addr eno1 --listen-addr eno1 --token SWMTKN-1-5hv1a7xzv1jmvlnqy1e8s11fkw3xwndyrve7yw288t19ql30jm-3b7m6ydohjzge5u6xcu836reo 10.0.1.11:2377
NEW_JOIN=`echo "${SWARM_JOIN}" | sed s/"join --token"/"join --advertise-addr eno1 --listen-addr eno1 --token"/g`

echo "SWARM_JOIN=${NEW_JOIN}"

# Have the other docker nodes join the swarm
ansible working -b -a "${NEW_JOIN}"

# Validate the SWARM
ansible os01 -b -a 'docker node ls'

# Create the base directories to devices to be used in cluster.
ansible working -b -a 'mkdir -p /data /data_1'

# Cycle docker
ansible-playbook ../environment/bare_metal/restart_docker.yaml
