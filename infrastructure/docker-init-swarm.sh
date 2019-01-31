# Run the ../kubernetes/install_k8s.yaml playbook across the cluster first.

# Initialize Docker Swarm
ansible os01 -b -a 'docker swarm init --advertise-addr 10.0.1.11 --listen-addr 10.0.1.11'
ansible os01 -b -a 'docker info'

# Create the core hdp_base network
# This network is used by all of the built clusters.  Since each cluster is attached
# to this network, they can all see each other, which is important to support
# cross cluster efforts.
ansible os01 -b -a 'docker network create --driver=overlay --gateway 192.168.50.1 --subnet 192.168.50.0/22 --attachable hwx'
