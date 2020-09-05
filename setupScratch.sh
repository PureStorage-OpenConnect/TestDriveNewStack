#!/usr/bin/env bash

set -o errexit
set -o pipefail

echo "#####################################"

APACKG=( epel-release python3 python3-pip centos-release-ansible-29 ansible vim python2-jmespath )


echo "####  Installing Python3 and Ansible  ####"

for pkg in "${APACKG[@]}";do
    if yum -q list installed "$pkg" > /dev/null 2>&1; then
        echo -e "$pkg is already installed"
    else
        yum install "$pkg" -y && echo "Successfully installed $pkg"
    fi
done

# Install SDK

echo "####  Installing the Pure Storage SDK  ####"
pip3 install purestorage
pip3 install jmespath
# Install the Pure Storage collection

echo "#### Installing the Purestorage Ansible Collection  ####"

ansible-galaxy collection install purestorage.flasharray
