# Support SSSD in my container (Many thanks to Kat Petre for the solution!)

## install packages (in docker file)
### install SSS Pipes ( enabling user identity passthrough )
RUN yum install -y sssd-client sssd-krb5-common sudo libsss_idmap libsss_nss_idmap libsss_sudo sssd-common krb5-workstation krb5-lib

### start container with -v parameters (other optional, for refernece only)
docker run -idt --name meamsets2 -p 18631:18630 \
-v /var/lib/sss/pipes/:/var/lib/sss/pipes/:rw \
-v /var/lib/sss/mc/:/var/lib/sss/mc/:ro \
--dns=192.168.1.174 --dns-search=evilcorp.internal \
--hostname=`hostname` \
--entrypoint=/sbin/init \
meamsets

# Security for sshd

I've removed the embedded keys to avoid issues with a shared key providing access to all containers.

Mount the /root/.ssh directory to a location on the baremetal host that has 'your' keys.

