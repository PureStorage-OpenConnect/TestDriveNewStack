#!/usr/bin/env bash

set -o errexit
set -o pipefail

#generate an ssh key for local login, this is required as kubespray uses ansible to log in to the nodes it installs:
echo "#### Generate SSH keys on local install ####"
ssh-keygen -t rsa -N '' -q -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#clone required repositories
echo "#### Clone kubespray repo and copy inventory in to repo ####"
git clone -b release-2.7 https://github.com/kubernetes-sigs/kubespray ~/kubespray

# Move inventory and other kubespray variables in to place
cp -rfv ~/TestDriveNewStack/Resources/inventory/testdrive ~/kubespray/inventory/


# Install prereqs as we now have pip3
echo "#### Install kubespray prereqs ####"
pip3 install -r requirements.txt

# Install kubernetes
echo "#### Install kubernetes ####"
cd ~/kubespray
ansible-playbook -i ~/TestDriveNewStack/resources/kubernetes/inventory/testdrive/inventory.ini cluster.yml -b


echo "#### Install snapshot providers ####"

# install CRD with Beta release
kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

#Add the snap controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml

sleep 15

#Install PSO
echo "#### Update helm repos and install PSO ####"
helm repo add pure https://purestorage.github.io/pso-csi
helm repo update
helm install pure-storage-driver pure/pure-pso --version 6.0.1 --namespace default -f ~/TestDriveNewStack/resources/kubernetes/pso_values.yaml

sleep 30

#Install the purestorage snapshot class
kubectl apply -f https://raw.githubusercontent.com/purestorage/pso-csi/master/pure-pso/snapshotclass.yaml


echo "#### Changing hostname ####"

# Fix the hostname as the case doesn't match the flasharray in testdrive.
# This is only needed for ansible playbooks
echo "linux" > /etc/hostname
systemctl restart systemd-hostnamed
sleep 3
