# WARNING

**This REPO is not functioning yet**

# Build notes

Placeholder for internal build notes.




# TestDriveNewStack

This project was born out of a desire to offer our SE's, our customers, and potential customers a simple, concise, example of how valuable [Pure Service Orchestrator](https://github.com/purestorage/pso-csi#pure-service-orchestrator-pso-csi-driver)  and [Ansible Automation](https://galaxy.ansible.com/purestorage) could, or will, be in their environment.

Make sure to run `setup.sh` in order to set up your Pure Test Drive environment.



## Try out Ansible

Run install_ansible.sh and then you can run `ansible-playbook <filename>`

The playbooks are straightforward, and actually demonstrate many of the things that Ansible is great at doing.

* 0_getInfo.yaml - Shows a simple method of gathering data - Requires vault password of **pure**.
* 1_modHost.yaml - Fixes some inconsistent capitalization between the host and the array.
* 2_createVol.yaml - You can see how Anible will create, map, format, mount, and edit /etc/fstab, all in one easy command.
* 3_createActiveCluster.yaml - Shamelessly stolen from @sdodsley, this will create a synchronous relationship between 2 Flasharrays and protect our volume
* 4_createSnaps.yaml - Creates a snapshot of our new volume, copies it to a new volume, and then mounts it on our test linux server
* 5_devSnaps.yaml - Hand this off to your development team and they will be able to refresh data on their own! No need to involve a storage admin.

As you can see, they are simple, self describing, and above all, *functional*. We would love to provide you with a Pure Test Drive voucher so you can try these out on your own!

Click here for more about [Pure Test Drive](https://www.purestorage.com/products/flasharray-x/test-drive.html)



## Try out Kubernetes with Kubespray

Need persistent storage for your containers? Well, now you can simply have Kubernetes spin up a container and all you need to do is state whether or not you block or file, and how much!

Here are some files to get you started. Simply run `kubectl apply -f <filename>` to get started.

* 1_createPVC.yaml - will create a persistent volume claim and let you see you easily interact with the Pure FlashArray.
* 2_minio.yaml -
* 3_service.yaml -
* 4_createsnap.yaml
* 5_restoresnap.yaml
* 6_minio-2.yaml
* 7_service-2.yaml



For any questions, reach out to bkuebler<at>gmail.com or chris<at>ccrow.org
