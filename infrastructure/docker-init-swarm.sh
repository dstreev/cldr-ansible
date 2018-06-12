# Run the ../kubernetes/install_k8s.yaml playbook across the cluster first.

# Initialize Docker Swarm
ansible os01 -b -a 'docker swarm init --advertise-addr 10.0.1.11 --listen-addr 10.0.1.11'
ansible os01 -b -a 'docker info'

# Create the core network (Docker recommends only setting up /24 networks)
ansible os01 -b -a 'docker network create --driver=overlay --gateway 192.168.44.1 --subnet 192.168.44.1/24 --attachable home'
