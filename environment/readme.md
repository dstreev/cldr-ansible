# Environment

This directory is used to manage a cluster environment.

The environment is a set of bare metal hardware with Kubernetes and Docker installed and configured with a swarm network.


[Kubernetes Installation Doc](https://kubernetes.io/docs/setup/independent/install-kubeadm/)

I'm doing the Docker CE installation.  Not directly supported yet in the docs.  I guess we'll find out if it works with this version of K8s.


# configuring a new host for the cluster.

- CENTOS 7 install
- yum update -y # to bring current
- ipa client registration
    - yum install -y ipa-client
    - `ipa-client-install --force-ntpd`
- On IPA Server:
    - Add Hosts `1.0.10.in-addr.arpa.` records.  'Record Name' is the last ip octet.  Ensure hostname ends with '.'
        - Without this, reverse DNS won't work and a lot of Kerb issues will happen.  IE: Like references about the hostname not having access, but the 'ip addr' does.
- Initialize Hosts with:
    - os_pre_reqs.yaml
    - set_hwx_dirs.yaml
    - local_hwx_users.yaml
    - ambari_install.yaml        
        