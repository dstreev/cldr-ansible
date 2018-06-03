# Run the ../kubernetes/install_k8s.yaml playbook across the cluster first.

# Bring down swarm
ansible hdp -b -a 'docker swarm leave'
ansible os1 -b -a 'docker swarm leave --force'
