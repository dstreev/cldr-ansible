#!/usr/bin/env python

import yaml
import subprocess
import os
import sys
import argparse
# https://docs.python.org/2/library/argparse.html#
parser = argparse.ArgumentParser(description='Deploy Cluster')
parser.add_argument('-i', type=int, dest="instance", nargs=1, required=True, help='the cluster instance')

args = parser.parse_args()
instance = args.instance[0]
print (instance)

#
print("Current Working Directory " , os.getcwd())
script_path = os.path.dirname(os.path.abspath( __file__ ))
print ("Script Path: ", script_path)
os.chdir(script_path)
print("Current Path: ", os.getcwd())

y = yaml.load(open("../config/template-2.6.yaml"))

print (y['blueprint_name'])

# subprocess.call(['ansible','localhost','-a','df -h'])
