#!/usr/bin/env bash

# This is only to be used as a prep for the Pure Test Drive Environment
# It will install the most optimal Python3 version, as well as set up Ansible.
# Brian Kuebler 9/7/20

set -o errexit
set -o nounset
set -o pipefail

function main() {

  #Call for any external install files
  kubesprayinstall="./installKubernetes.sh"     #get the most recent kubespray install
  ansibleinstall="./installAnsible.sh"

  # Install necessary packages. Currently, only python2 installed.
  # Setup host keys for ansible
  function genKeys () {
  echo "#### Generate SSH keys on local install ####"
  if [[ -f /root/.ssh/id_rsa ]];then
      echo "Skipping ssh-keygen. id_rsa already exists"
  else
      ssh-keygen -t rsa -N '' -q -f /root/.ssh/id_rsa
      #Add localhost to known_hosts
      ssh-keyscan -H localhost >> ~/.ssh/known_hosts
      #cat ~/.ssh/id_rsa.pub >> /home/pureuser/.ssh/authorized_keys
      #Populate the 'known_hosts' file
      sshpass -p pureuser ssh-copy-id root@localhost
  fi
  }

  function setAuthorizedKeys () {
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
  }


  function testSSH() {
    ssh localhost uptime
  }


  if [[ $? -eq 0 ]];then
    echo "SSH is all good."
  else
    echo "##########################################################"
    echo "#### Check for ssh files before running playbooks ########"
    echo "##########################################################"
    echo " "
    echo " "
  fi

  function installPackages() {
    #install all required Linux packages
    APACKG=( epel-release
             python3
	     python3-pip
             sg3_utils
             centos-release-ansible-29
             ansible
             vim
             python2-jmespath
             sshpass
           )

    echo "##########################################"
    echo "####  Installing Python3 and Ansible  ####"
    echo "##########################################"
    echo " "

    for pkg in "${APACKG[@]}";do
        if yum -q list installed "$pkg" > /dev/null 2>&1; then
            echo -e "$pkg is already installed"
        else
            yum install "$pkg" -y && echo "Successfully installed $pkg"
        fi
    done
  
  #You don't need to use these, but they can help with less typing.

    echo "" >> ~/.bashrc
    echo "alias ap='ansible-playbook'" >> ~/.bashrc
    echo "alias P='cd ~/ansibletest/Playbooks'" >> ~/.bashrc

  }

  function setApi() {
      fa1_ip='10.0.0.11'
      fa2_ip='10.0.0.21'


        sshpass -p pureuser ssh -o StrictHostKeyChecking=no pureuser@${fa1_ip} "pureadmin create --api-token pureuser"
        sshpass -p pureuser ssh -o StrictHostKeyChecking=no pureuser@${fa2_ip} "pureadmin create --api-token pureuser"

        fa1_token=$(sshpass -p pureuser ssh pureuser@${fa1_ip} "pureadmin list --api-token --expose --notitle pureuser" | awk '{print $3}')
        fa2_token=$(sshpass -p pureuser ssh pureuser@${fa2_ip} "pureadmin list --api-token --expose --notitle pureuser" | awk '{print $3}')
        echo "fa1_token: $fa1_token" >> ./resources/testdrive_vars.yaml
        echo "fa2_token: $fa2_token" >> ./resources/testdrive_vars.yaml
        sed -i "s/FA1Token/${fa1_token}/g" ./resources/kubernetes/pso_values.yaml
        sed -i "s/FA2Token/${fa2_token}/g" ./resources/kubernetes/pso_values.yaml

  }

  function installAnsible() {
    #statements
    if [[ -f $ansibleinstall ]]; then
      echo "will run file $ansibleinstall"
      $ansibleinstall
    else
      echo "Please check to make sure that $ansibleinstall exists"
    fi
  }
  echo " "


  #Let's run everything
  installPackages
  genKeys
  testSSH
  setApi
  installAnsible

  sleep 3
  echo " "
  echo "Installation complete. Run 'source .bashrc'\
   in your home directory order to use new aliases."
  echo " "
}
if [[ $(id -u) -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [[ "$PWD" == /root/TestDriveNewStack || "$PWD" == "$HOME" ]];then
  main
else
  echo "You are in "${PWD}". Please clone or copy to, and then run in /root/TestDriveNewstack"
fi
