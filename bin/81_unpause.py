#!/usr/bin/env python

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
cfgPath = '../config/' + str(instance) + '.yaml'

# Load cfg
cfgYaml = yaml.load(open(cfgPath))
# Environment Set which location
env_set = cfgYaml["env_set"]
docker_stack = 'hdp' + str(instance)

# Cycle through the Container on each host looking for an ENV_INSTANCE
# match, then pause the container.

# Paused
# 30575e83d2fd        dstreev/centos7_sshd:105   "/usr/bin/supervisor…"   5 hours ago         Up 5 hours (Paused)   0.0.0.0:22011->22/tcp   hdp11_os15.1.pb2zpx5nl0erk86k176gw33d1
# Loop through docker hosts
hosts = ['01','02','03','04','05','06','07','10','11','12','13','14','15','16','17','18','19']
for host in hosts:
  # Loop through containers the are NOT Pause and are part of the Docker Stack
  print('Checking Docker host os' + host + ' for running containers the are part of Stack hdp' + str(instance))

  out = subprocess.check_output(['docker','-H','os'+host+':2375','ps'])

  for line in out.splitlines():
      if (re.search(docker_stack, line.decode('utf-8'))):
          # When docker_stack, check if it's paused
          if (re.search('Paused',line.decode('utf-8'))):
              # When not paused
              fields = line.decode('utf-8').strip().split()
              container = fields[0]
              print ('Paused container: ' + container + ' found.  Unpausing now.')
              # Pause the container
              out = subprocess.Popen(['docker','-H','os'+host+':2375','unpause', container])
