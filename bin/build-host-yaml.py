#!/usr/bin/env python

import yaml
import fileinput
import subprocess
import os
import sys
import argparse
import re
from shutil import copy2
from jinja2 import Environment, Template, FileSystemLoader

os.chdir(os.path.dirname(os.path.abspath( __file__ )))

# https://docs.python.org/2/library/argparse.html#
parser = argparse.ArgumentParser(description='Deploy Cluster')
parser.add_argument('-i', type=int, dest="instance", nargs=1, required=True, help='the cluster instance')

args = parser.parse_args()
instance = args.instance[0]
print (instance)
cfgPath = '../config/' + str(instance) + '.yaml'
if (os.path.isfile(cfgPath)):
    cfgYaml = yaml.load(open(cfgPath))
    # print(cfgYaml)
    # Environment Set which location
    env_set = cfgYaml["env_set"]
    # print ("Env_Set: " + env_set)
    env = Environment(
        loader = FileSystemLoader('../environment/hosts')
    )
    # loader = FileSystemLoader('../environment/hosts/host-template_" + env_set + ".yaml')
    template = env.get_template('host-template_' + env_set + '.yaml')
    # template = Template(open("../environment/hosts/host-template_" + env_set + ".yaml"))
    instance_cfg = template.render(cfgYaml)

    text_file = open("../environment/hosts/" + str(instance) + ".yaml", "w")

    text_file.write(instance_cfg)

    text_file.close()
