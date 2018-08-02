#!/usr/bin/env python

import yaml
import subprocess
import os
import sys
import argparse
import re
import time
from jinja2 import Environment, Template, FileSystemLoader

# https://docs.python.org/2/library/argparse.html#
parser = argparse.ArgumentParser(description='Deploy Cluster')
parser.add_argument('-i', type=int, dest="instance", nargs=1, required=True, help='the cluster instance')
parser.add_argument('-bp', dest="bp", required=False, help='Install from Blueprint')

args = parser.parse_args()
instance = args.instance[0]

# Change to script file directory
os.chdir(os.path.dirname(os.path.abspath( __file__ )))

# Set the config file
cfgPath = '../config/' + str(instance) + '.yaml'

# Function to run host ansible scripts
# TODO:

if (os.path.isfile(cfgPath)):
    # check_for_infra=subprocess.check_output('ansible localhost -a "ls -al" | grep -v "test"')
    # Check to see if the INFRA stack has been deployed.
    docker_stack = 'hdp'+str(instance)
    print ("Checking if Stack " + docker_stack + " has already been deployed")
    check_stack = False
    out = subprocess.check_output(['docker', '-H', 'os01:2375', 'stack', 'ls'])
    for line in out.splitlines():
        # print('Line: '+ line.decode('utf-8'))
        if (re.search(docker_stack, str(line))):
            check_stack = True

    if ( not check_stack ):
        cfgYaml = yaml.load(open(cfgPath))
        # Environment Set which location
        env_set = cfgYaml["env_set"]
        docker_stack = 'hdp' + str(instance)

        env = Environment(
            loader = FileSystemLoader('../hdp/setup/stack-compose')
        )

        template = env.get_template(env_set + '.yaml')
        instance_cfg = template.render(cfgYaml)

        # With the compose template, create a qualified composefile and save to tmp.
        text_file = open('/tmp/resolved_'+env_set + '.yaml', 'w')
        text_file.write(instance_cfg)
        text_file.close()

        # Now Deploy
        print('Deploy Docker Stack '+ docker_stack + ' with compose file (' + env_set + ')')
        subprocess.call(['docker','-H','os01:2375','stack','deploy','--compose-file','/tmp/resolved_'+env_set + '.yaml', docker_stack], stderr=subprocess.STDOUT)

        print('Pause for 25 seconds while the docker services start')
        time.sleep(25)

        # Populate Deployment readme.md
        print('Set Readme Docs.')
        subprocess.call(['ansible-playbook', '--extra-vars','@../config/'+str(instance)+'.yaml', '--tags', 'add', '../config/config-dictionary.yaml'], stderr=subprocess.STDOUT)

    else:
        print('Stack has already been deployed.')
        print('   True up configurations...')

    print('Build the Host File for instance: '+ str(instance))
    subprocess.call(['./build-host-yaml.py','-i',str(instance)], stderr=subprocess.STDOUT)

    # echo "OS Prep"
    print('OS Prep')
    subprocess.call(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/setup/hdp_os_prep.yaml'], stderr=subprocess.STDOUT)

    print('Edge Node Config')
    subprocess.call(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/setup/edge_node_config.yaml'], stderr=subprocess.STDOUT)

    print('Ambari Install Playbook')
    subprocess.call(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/ambari/ambari_install.yaml'], stderr=subprocess.STDOUT)

    if (args.bp):
        print('Ambari Blueprint Install Playbook')
        subprocess.call(['ansible-playbook', '-i', '../environment/hosts/'+str(instance)+'.yaml','--extra-vars','@../config/'+str(instance)+'.yaml', '../hdp/ambari/ambari_blueprint_install.yaml'], stderr=subprocess.STDOUT)

else:
    print('Could not find config file: ' + cfgPath)
