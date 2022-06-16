#!/usr/bin/env bash

set -euo pipefail

# Wait to avoid race condition where Ubuntu wants to do an automated
# system upgrade at boot, causing later apt-get commands to sometimes
# fail with obscure error messages.
sleep 15

# Create a directory to catch any temporary files that were created,
# so they can be easily cleaned up and not make it into the generated
# AMI.
mkdir /tmp/riju-work
pushd /tmp/riju-work

export DEBIAN_FRONTEND=noninteractive

# Perform full system upgrade at start so we have all the latest
# packages regardless of base AMI.
sudo -E apt-get update
sudo -E apt-get dist-upgrade -y

# Install and start MicroK8s. Unfortunately, there is no way to do
# this that does not involve Snap, because Canonical really wants to
# force it down everyone's throats.
sudo snap install microk8s --classic
sudo microk8s status --wait-ready

# Install the AWS CLI as we will need it from EC2 userdata.
wget -nv https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O awscli.zip
unzip -q awscli.zip
sudo ./aws/install

popd
rm -rf /tmp/riju-work
