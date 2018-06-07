FROM centos:centos7

LABEL maintainer "David W. Streever<david@streever.com>"

RUN yum -y install epel-release

# Update the OS before continuing and install the yum-utils module
RUN yum -y update
RUN yum -y install yum-utils unzip wget gettext
RUN yum -y install less
RUN yum -y install net-tools
RUN yum -y install iproute
RUN yum -y install openssl openssh-server openssh-clients passwd
RUN yum -y install supervisor
RUN yum -y install ntp
RUN yum -y install ansible
RUN yum -y install pdsh
RUN yum -y install nscd
RUN yum -y install bind-utils
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install java-1.8.0-openjdk-devel
RUN yum -y install git
RUN yum -y install sssd sssd-client
RUN yum -y install chrony

# Generate Host Key for sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# Supervisord Config
#COPY ./init/supervisord.ini /etc/supervisord.d/hdp.ini

# JDK
#WORKDIR /tmp
#RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm
#RUN rpm -ivh jdk-8u161-linux-x64.rpm && rm jdk-8u161-linux-x64.rpm

# Download and install the Hadoop CLI
#RUN wget https://github.com/dstreev/hadoop-cli/releases/download/1.0.7.2.7-bin/hadoop-cli-1.0.7-SNAPSHOT-2.7.tar.gz
#RUN tar -xzvf hadoop-cli-1.0.7-SNAPSHOT-2.7.tar.gz
#RUN hadoop-cli-2.7/setup.sh

WORKDIR /root

RUN mkdir .ssh
RUN chmod 600 .ssh

COPY ./keys/id_rsa .ssh/
COPY ./keys/id_rsa.pub .ssh/
COPY ./keys/id_rsa.pub .ssh/authorized_keys

# Supervisord Config
COPY ./init/supervisord.ini /etc/supervisord.d/hdp.ini
# Try to fix timeout issues in docker overlay network.
COPY ./init/50_net.conf /etc/sysctl.d/50_net.conf

EXPOSE 22

VOLUME ["/data_0","/data_1","/var/log/hadoop","/var/log/hadoop-yarn","/var/log/hadoop-mapreduce","/var/log/hive","/var/log/hbase","/var/log/oozie","/var/log/falcon","/var/log/atlas","/var/log/zookeeper","/var/log/ambari-infra-solr","/var/log/kafka"]

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.d/hdp.ini"]
