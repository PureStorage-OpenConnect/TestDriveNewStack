#!/usr/bin/env bash

# This is only to be used as a prep for the Pure Test Drive Environment
# It will install the most optimal Python3 version, as well as set up Ansible.
# Brian Kuebler 9/7/20

set -o errexit
set -o nounset
set -o pipefail

function main() {
  #statements

  #Call for any external install files
  kubesprayinstall="./installKubernetes.sh"     #get the most recent \
                                                  #kubesprayinstall
  ansibleinstall="./installAnsible.sh"
  # Install necessary packages. Currently, only python2 installed.
  # Setup host keys for ansible
  echo "#### Generate SSH keys on local install ####"
  ssh-keygen -t rsa -N '' -q -f ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  #Populate the 'known_hosts' file
  ssh -oStrictHostKeyChecking=no localhost echo "Probably a better way to set known_hosts :-/"

  function testSSH() {
    ssh localhost uptime
  }
  testSSH

  if [[ $? -eq 0 ]];then
    echo "SSH is all good."
  else
    echo "###########################################################"
    echo "Check for ssh files before running playbooks"
    sleep 5
  fi

  echo " "
  echo " "
  echo "#############################################################"
  echo " "
  echo " "
  function installPackages() {
    #install all required Linux packages
    APACKG=( epel-release
             python3 python3-pip
             centos-release-ansible-29
             ansible
             vim
             python2-jmespath )

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

  function installAnsible() {
    #statements
    if [[ -f $ansibleinstall ]]; then
      echo "will run file $ansibleinstall"
      $ansibleinstall
    else
      echo "Please check to make sure that $kubesprayinstall exists"
    fi
  }
  echo " "
  function installKubernetes() {

    if [[ -f $kubesprayinstall ]]; then
      while true; do
          read -p "Do you wish to install Kubernetes?" yn
          case $yn in
              [Yy]* ) $kubesprayinstall;break;;
              [Nn]* ) exit;;
              * ) echo "Please answer yes or no.";;
          esac
      done
    else
      echo "Please check to make sure that $kubesprayinstall exists"
    fi
  }


  #Let's run everything
  installPackages
  installAnsible
  echo " =============================== "
  echo " "
  echo "If you'd like to install Kubernetes, answer 'yes' to the next prompt"
  echo "Please note that it could take up to 15 minutes to prepare. "
  echo "If you answer 'no', you can manually run the installKubernetes.sh script"
  echo "when you'd like"
  echo " "
  echo " ===================="
  installKubernetes

  sleep 3
  echo " "
  echo "Installation complete. Run 'source .bashrc'\
   in your home directory order to use new aliases."
  echo " "
}

if [[ "$PWD" == /root/TestDriveNewStack || "$PWD" == "$HOME" ]];then
  main
else
  echo "You are in "${PWD}". Please clone or copy to, and then run in /root/TestDriveNewstack"
fi
