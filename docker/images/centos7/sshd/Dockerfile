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
RUN yum -y install which
RUN yum -y install sudo

RUN wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
RUN yum -y install docker-ce

# To support SSSD Bindings to underlying baremetal host.
RUN yum install -y sssd-client sssd-krb5-common sudo libsss_idmap libsss_nss_idmap libsss_sudo sssd-common krb5-workstation krb5-lib

RUN groupadd hadoop

RUN useradd ams;useradd atlas;useradd ambari-qa; useradd druid; useradd hdfs; useradd hbase; useradd hive; useradd infra-solr; useradd kafka; useradd kms; useradd knox; useradd livy; useradd logsearch; useradd mapred; useradd oozie; useradd ranger; useradd spark; useradd sqoop; useradd superset; useradd tez; useradd yarn-ats; useradd yarn; useradd zeppelin; useradd zookeeper

RUN usermod -a -G hadoop ams; usermod -a -G hadoop atlas; usermod -a -G hadoop ambari-qa; usermod -a -G hadoop druid; usermod -a -G hadoop hdfs; usermod -a -G hadoop hbase; usermod -a -G hadoop hive; usermod -a -G hadoop infra-solr; usermod -a -G hadoop kafka; usermod -a -G hadoop kms; usermod -a -G hadoop knox; usermod -a -G hadoop livy; usermod -a -G hadoop logsearch; usermod -a -G hadoop mapred; usermod -a -G hadoop oozie; usermod -a -G hadoop ranger; usermod -a -G hadoop spark; usermod -a -G hadoop sqoop; usermod -a -G hadoop superset; usermod -a -G hadoop tez; usermod -a -G hadoop yarn-ats; usermod -a -G hadoop yarn; usermod -a -G hadoop zeppelin; usermod -a -G hadoop zookeeper

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

# Mount the root/.ssh directory to a baremetal host mount.

VOLUME ["/var/lib/sss/pipes","/var/lib/sss/mc","/hadoop","/var/log"]

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.d/hdp.ini"]
