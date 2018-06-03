#!/bin/bash

echo "**** SSHD-BASE *****"
docker build --tag dstreev/centos7_sshd:latest ./centos7/sshd
