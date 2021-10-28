#### *Note that this project is for educational purposes only, and is meant to demonstrate what you can do with Pure. These playbooks and scripts have been developed only for use only in Pure Test Drive. You're free to adapt them to your environment, but you're responsible for testing and overall functionality. Have fun!*

# TestDriveNewStack

This project was born out of a desire to offer our SE's, our customers, and potential customers a simple, concise way to see how [Ansible Automation](https://galaxy.ansible.com/purestorage) could, or will, help them in their environment.

Make sure to run `setup.sh` in order to set up your Pure Test Drive environment.

## Build Notes
* You can now create volumes with user input, feel free to modify for use with both virtual FlashArrays!


## Getting started

**NOTE: With the updated TestDrive Interfaces the many items have changed. Please validate you are using the latest repo.**

Launch an "Introduction to FlashArray" lab from Pure TestDrive. 

> Note that these scripts will not run in other environments without modification.

Log in to the Linux VM (linux1) as root (password can be found under the TestDrive credentials tab) using the desktop icon or putty.

Install git with:

```bash
yum install git -y
```

clone the repo with:

```bash
git clone https://github.com/PureStorage-OpenConnect/TestDriveNewStack
```

Run the setup.sh script by typing the following:

```bash
cd TestDriveNewStack
./setup.sh
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


For any questions, reach out to bkuebler\@gmail.com or chris\@ccrow.org
