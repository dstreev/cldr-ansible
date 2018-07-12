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
    # out = proc.communicate()
    for line in out.splitlines():
        if (re.search(docker_stack, str(line))):
            check_stack = True

    if ( check_stack):
        print('Removing Docker Stack: ' + docker_stack)
        out = subprocess.check_output(['docker','-H','os01:2375','stack','rm',docker_stack])

        # Populate Deployment readme.md
        print('Set Readme Docs.')
        out = subprocess.check_output(['ansible-playbook', '--extra-vars','@../config/'+str(instance)+'.yaml', '--tags', 'remove', '../config/config-dictionary.yaml']).communicate()
    else:
        print('Docker stack not found: ' + docker_stack)
else:
    print('Could not find config file: ' + cfgPath)
