#!/usr/bin/env python3

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

#print(os.environ["HWX_CFG_DIR"])

host_yaml_file_ref = os.environ['HWX_CFG_DIR']+'/hosts/'+str(instance)+'.yaml'
cfg_yaml_file_ref = os.environ['HWX_CFG_DIR']+'/config/'+str(instance)+'.yaml'

print (instance)
# cfgPath = '../config/' + str(instance) + '.yaml'
if (os.path.isfile(cfg_yaml_file_ref)):
    cfgYaml = yaml.load(open(cfg_yaml_file_ref), Loader=yaml.FullLoader)
    # print(cfgYaml)
    # Environment Set which location
    deploy_type = cfgYaml["deploy_type"]
    env_set = cfgYaml["env_set"]
    env_type = cfgYaml["env_type"]

    print ("Env_Set: " + env_set)
    env = Environment(
        loader = FileSystemLoader('../environment/templates/'+deploy_type+'/'+env_type)
    )
    # loader = FileSystemLoader('../environment/hosts/host-template_" + env_set + ".yaml')
    template = env.get_template(env_set + '.yaml')
    # template = Template(open("../environment/hosts/host-template_" + env_set + ".yaml"))
    instance_cfg = template.render(cfgYaml)

    text_file = open(host_yaml_file_ref, "w")

    text_file.write(instance_cfg)

    text_file.close()
