#!/usr/bin/env python

import yaml
import subprocess
import os
import sys
import argparse
import re
import time

# https://docs.python.org/2/library/argparse.html#
parser = argparse.ArgumentParser(description='Deploy Cluster')
parser.add_argument('-i', type=int, dest="instance", nargs=1, required=True, help='the cluster instance')

args = parser.parse_args()
instance = args.instance[0]

# Change to script file directory
os.chdir(os.path.dirname(os.path.abspath( __file__ )))

# Set the config file
cfgPath = '../config/' + str(instance) + '.cfg'

# Function to run host ansible scripts
# TODO:

if (os.path.isfile(cfgPath)):
    # check_for_infra=subprocess.check_output('ansible localhost -a "ls -al" | grep -v "test"')
    # Check to see if the INFRA stack has been deployed.
    docker_stack = 'hdp'+str(instance)
    print ("Checking if Stack " + docker_stack + " has already been deployed")
    out, err = subprocess.Popen(['docker', '-H', 'os01:2375', 'stack', 'ls'])
    check_stack = False
    for line in out.splitlines():
        if (re.search(docker_stack), str(line)):
            check_stack = True

    if ( not check_stack):
        cfgYaml = yaml.load(open(cfgPath))
        # Environment Set which location
        env_set = cfgYaml["env_set"]
        docker_set = 'hdp' + env_set

        # Now Deploy
        print('Deploy Docker Stack '+ docker_stack + 'with compose file (' + env_set + ')')
        out, err = subprocess.Popen(['docker','-H','os01:2375','stack','deploy','--compose-file','../hdp/setup/stack-compose/'+env_set+'.yaml', docker_stack])


        print('Build the Host File for instance: '+ str(instance))
        out, err = subprocess.Popen(['./build-host-yaml.py','-i',instance])

        print('Pause for 15 seconds while the docker services start')
        # time.sleep(15)

        # echo "OS Prep"
        print('OS Prep')
        # out, err = subprocess.Popen(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/setup/hdp_os_prep.yaml'])
        # ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/hdp_os_prep.yaml

        print('Edge Node Config')
        # out, err = subprocess.Popen(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/setup/edge_node_config.yaml'])
        # ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/setup/edge_node_config.yaml

        print('Ambari Install Playbook')
        # out, err = subprocess.Popen(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/setup/ambari_install.yaml'])
        # ansible-playbook -i ../environment/hosts/${ENV_INSTANCE}.yaml --extra-vars "@../environment/vars/ambari_${AMBARI_VERSION}.json" -e env_state=started ../hdp/ambari/ambari_install.yaml

        # Populate Deployment readme.md
        print('Set Readme Docs.')
        # out, err = subprocess.Popen(['ansible-playbook', '--extra-vars','@../config/'+str(instance)+'.yaml', '--tags', 'add', '../config/config-dictionary.yaml'])
        # ansible-playbook -e ENV_INSTANCE=${ENV_INSTANCE} -e ENV_SET=${ENV_SET} -e AMBARI_VERSION=${AMBARI_VERSION} -e HDP_STACK_VERSION=${HDP_STACK_VERSION} --tags "add" ../config/config-dictionary.yaml


else:
    print("Nothing")
