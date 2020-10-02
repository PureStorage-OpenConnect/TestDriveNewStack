#!/usr/bin/env bash

# This is only to be used as a prep for the Pure Test Drive Environment
# It will install the most optimal Python3 version, as well as set up Ansible.
# Brian Kuebler 9/7/20

set -o errexit
set -o nounset
set -o pipefail

# Install the Pure Storage SDK. This is required for Pure Service Orchestrator.

function installSDK() {
  echo " "
  echo "###########################################"
  echo "####  Installing the Pure Storage SDK  ####"
  echo "###########################################"
  echo " "
  python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org purestorage
  python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org jmespath
}

# Install the Pure Storage collection
function installCollections() {
echo " "
echo "########################################################"
echo "#### Installing the Purestorage Ansible Collection  ####"
echo "########################################################"
echo " "
ansible-galaxy collection install purestorage.flasharray
}

installSDK
installCollections

echo "Ansible Install complete"
