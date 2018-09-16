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


# Set the locations
cfg_path = os.environ['HWX_CFG_DIR']+'/config'
host_path = os.environ['HWX_CFG_DIR']+'/hosts'

cfg_file = os.environ['HWX_CFG_DIR']+'/config/' + str(instance) + '.yaml'
host_file = os.environ['HWX_CFG_DIR']+'/hosts/' + str(instance) + '.yaml'

class Deployment(object):
    def swarm(self, cfgYaml):
        print("Swarm Deployment............." + cfgYaml["env_set"])
        # Environment Set which location
        env_set = cfgYaml["env_set"]

        # TODO: Check to see if the INFRA stack has been deployed.
        docker_stack = 'hdp'+str(instance)
        print ("Checking if Stack " + docker_stack + " has already been deployed")
        check_stack = False
        out = subprocess.check_output(['docker', '-H', 'os01:2375', 'stack', 'ls'])
        for line in out.splitlines():
            # print('Line: '+ line.decode('utf-8'))
            if (re.search(docker_stack, str(line))):
                check_stack = True

        if ( not check_stack ):
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
            # subprocess.call(['docker','-H','os01:2375','stack','deploy','--compose-file','/tmp/resolved_'+env_set + '.yaml', docker_stack], stderr=subprocess.STDOUT)

            print('Pause for 25 seconds while the docker services start')
            # time.sleep(25)

            # Populate Deployment readme.md
            print('Set Readme Docs.')
            subprocess.call(['ansible-playbook', '--extra-vars','@'+cfg_file, '-e', 'cfg_path='+cfg_path, '--tags', 'add', '../config/config-dictionary.yaml'], stderr=subprocess.STDOUT)

        else:
            print('Stack has already been deployed.')
            print('   True up configurations...')

        print('Build the Host File for instance: '+ str(instance))
        subprocess.call(['./build-host-yaml.py','-i',str(instance)], stderr=subprocess.STDOUT)

        # echo "OS Prep"
        print('OS Prep')
        # subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/setup/hdp_os_prep.yaml'], stderr=subprocess.STDOUT)

        print('Edge Node Config')
        # subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/setup/edge_node_config.yaml'], stderr=subprocess.STDOUT)

        print('Ambari Install Playbook')
        # subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/ambari/ambari_install.yaml'], stderr=subprocess.STDOUT)

        if (args.bp):
            print('Ambari Blueprint Install Playbook')
            subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/ambari/ambari_blueprint_install.yaml'], stderr=subprocess.STDOUT)

    def baremetal(self, cfgYaml):
        print ("Bare metal Deployment......... ")

        # TODO: Check if cluster is already deployed
        check_stack = False

        if ( not check_stack ):
            # Populate Deployment readme.md
            print('Set Readme Docs.')
            subprocess.call(['ansible-playbook', '--extra-vars','@'+cfg_file,  '-e', 'cfg_path='+cfg_path, '--tags', 'add', '../config/config-dictionary.yaml'], stderr=subprocess.STDOUT)

        else:
            print('Stack has already been deployed.')
            print('   True up configurations...')

        print('Build the Host File for instance: '+ str(instance))
        subprocess.call(['./build-host-yaml.py','-i',str(instance)], stderr=subprocess.STDOUT)

        # Link Directories
        print('Switching Data Dir Link /hadoop to /hwx_data/' + str(cfgYaml['env_instance']) + '/' + cfgYaml['hdp_version'])
        subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../environment/baremetal/set_hwx_dirs.yaml'], stderr=subprocess.STDOUT)

        # echo "OS Prep"
        # print('OS Prep')
        # subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../environment/baremetal/os_pre_reqs.yaml'], stderr=subprocess.STDOUT)
        #
        # print('Setup Local Accounts')
        # subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../environment/baremetal/local_hwx_users.yaml'], stderr=subprocess.STDOUT)

        print('Edge Node Config')
        subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/setup/edge_node_config.yaml'], stderr=subprocess.STDOUT)

        print('Ambari Install Playbook')
        subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/ambari/ambari_install.yaml'], stderr=subprocess.STDOUT)

        if (args.bp):
            print('Ambari Blueprint Install Playbook')
            subprocess.call(['ansible-playbook', '-i', host_file,'--extra-vars','@'+cfg_file, '../hdp/ambari/ambari_blueprint_install.yaml'], stderr=subprocess.STDOUT)


    def k8s(self, cfgYaml):
        print ("k8s wip")


    def runDeploy(self, argument, cfgYaml):
        print("Arg:" + argument)
        method = getattr(self, argument, lambda: "No such deployment model")
        return method(cfgYaml)

if (os.path.isfile(cfg_file)):

    cfgYaml = yaml.load(open(cfg_file))
    deployment = Deployment()
    deploy_type = cfgYaml["deploy_type"]
    deployment.runDeploy(deploy_type, cfgYaml)

else:
    print('Could not find config file: ' + cfg_file)
