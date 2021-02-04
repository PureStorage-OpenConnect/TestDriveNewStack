#### *Note that this project is for educational purposes only, and is meant to demonstrate what you can do with Pure. These playbooks and scripts have been developed only for use only in Pure Test Drive. You're free to adapt them to your environment, but you're responsible for testing and overall functionality. Have fun!*

# TestDriveNewStack

This project was born out of a desire to offer our SE's, our customers, and potential customers a simple, concise, example of how valuable [Pure Service Orchestrator](https://github.com/purestorage/pso-csi#pure-service-orchestrator-pso-csi-driver)  and [Ansible Automation](https://galaxy.ansible.com/purestorage) could, or will, be in their environment.

Make sure to run `setup.sh` in order to set up your Pure Test Drive environment.

## Build Notes
* Added PSO via Kubespray
* You can now create volumes with user input, feel free to modify for use with both virtual FlashArrays!
* Added PSO Explorer, which you should definitely take a look at!

## Getting started

**NOTE: With the updated TestDrive Interfaces the many items have changed. Please validate you are using the latest repo.**

Launch an "Introduction to FlashArray" lab from Pure TestDrive. 

> Note that these scripts will not run in other environments without modification.

Log in to the Linux VM (linux1) as root (password can be found under the TestDrive credentials tab) using the desktop icon or putty.

Install git with:

```
yum install git
```

clone the repo with:
```
git clone https://github.com/PureStorage-OpenConnect/TestDriveNewStack
```

Run the setup.sh script by typing the following:
```
git checkout testdrive-beta
~/TestDriveNewStack/setup.sh
```

## Try out Ansible

Once setup is finished, you can then you can run `ansible-playbook --ask-vault-pass <filename>`. Requires vault password of **pure**.

Running them in order (0-6) is recommended.

The playbooks are straightforward and actually demonstrate many of the things that Ansible is great at doing.

* 0_getInfo.yaml - Shows a simple method of gathering data
* 1_modHost.yaml - Fixes some inconsistent capitalization between the host and the array.
* 2_createVol.yaml - You can see how Anible will create, map, format, mount, and edit /etc/fstab, all in one easy command.
* 3_createActiveCluster.yaml - Shamelessly stolen from @sdodsley, this will create a synchronous relationship between 2 Flasharrays and protect our volume
* 4_createSnaps.yaml - Creates a snapshot of our new volume, copies it to a new volume, and then mounts it on our test linux server
* 5_devSnaps.yaml - Hand this off to your development team and they will be able to refresh data on their own! No need to involve a storage admin.
* 6_createYourVol.yaml - This will allow you to specify your own volume name, size, and mount point. *Note that this will overwrite existing mounts, so only for demo purposes.*

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

After step 3, you can now log to minio using the service port. Find the port with the kubectl get svc (should always be 172.16.3.11 and 9000) command. http://<linuxIP>:<port> Username/password: minio:minio123

Continuing with the rest of the commands, which will take a snap and clone a new PVC from that snapshot. You can then continue with spinning up a new minio instance (default will be port 9001).

For a snap restore demo, you can scale to 0 replicas, restore the snap, and scale replicas to 1. The command to scale replicas is:
kubectl scale deploy minio-deployment --replicas=0

## Try out PSO Explorer

Pure Service Orchestrator™ Explorer (or PSO Explorer) provides a web based user interface for Pure Service Orchestrator™. It shows details of the persistent volumes and snapshots that have been provisioned using PSO, showing provisioned space, actual used space, performance and growth characteristics. The PSO Explorer dashboard provides a quick overview of the number of volumes, snapshots, storageclasses and arrays in the cluster, in addition to the volume usage, the volume growth over the last 24 hours and cluster-level performance statistics.

Install by running installPSOExplorer.sh

Check the status by running:
```
kubectl get service pso-explorer -n psoexpl
```

External IP doesn't currently populate, use the linux host IP and the port exposed with the above command (e.g. http://172.16.3.11:27011)

````
http://<ip address>:<port>/
````


For any questions, reach out to bkuebler\@gmail.com or chris\@ccrow.org
