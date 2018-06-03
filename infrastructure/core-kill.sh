# Needed to make 'core' Swarm Network available via:
# docker network ls
# This is called by ansible in the docker_container module when trying to attach
# a container to a network.
ansible os -b -a 'docker stop core-init'
ansible os -b -a 'docker rm core-init'
