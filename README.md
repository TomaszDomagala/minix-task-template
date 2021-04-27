# minix-task-template

This is a template for minix tasks. Create new repository by clicking "Use this template" button in the upper right corner.

### Getting started:
1. Go to the `/scripts` directory.
1. In the `.config` file change `username=ab123456` to your student index. This is used to access the students machine and for exporting the solution.
1. Run `download_image.sh` script. This will create `/images/base_image` directory, download minix.img.xz from students.mimuw.edu.pl and decompress it.
You may need to provide your password during this step.

### Creating new machine:
1. Run `create_image.sh` script. This will create new `minix.img` in the `/images` directory. 
Re-running this script always deletes previous image before creating a new one.
1. Using another terminal run `start_machine.sh` script. This will run qemu machine.
1. Run `set_up_machine.sh`. This will set up SSH key on the running machine and install rsync on it. 
If you don't have a ssh key, you may need to generate it using ssh-keygen.
1. Run `sync_machine.sh` script to sync local `/usr` and `/tests` with the running machine.

### Usage, syncing and reinstalling:
Edit minix source code in the `/sources/task/usr` directory and other programs in the `/tests` directory.
Sync changes with the running machine using `sync_machine.sh` script. Install changes using `reinstall_machine.sh` script.
If something went wrong, you can always create new image as in [Creating new image](#creating-new-image) section. 

### .patch file
To create `ab123456.patch` file, use `create_patch.sh` script. 
Apply patch to the **newly craeted** minix machine using `apply_patch.sh`.
Applying may fail if the running machine's files differ from original source.

#### Notes:
Minix sometimes crashes/freezes during ssh operations. 
Memory limit can be inceased to reduce the likelihood of it by setting bigger value for `-m` flag in `qemu-system-x86_64` command inside `start_machine.sh` script.


You can edit `reinstall_machine.sh` script to remove some `make && make install` commands if the current task does not involve all of the directories.
```bash

ssh -p "${ssh_port}" root@localhost << EOF
cd /usr/src
make includes
cd /usr/src/minix/fs/procfs
make && make install
cd /usr/src/minix/servers/pm
make && make install
cd /usr/src/minix/drivers/storage/ramdisk
make && make install
cd /usr/src/minix/drivers/storage/memory
make && make install
cd /usr/src/lib/libc
make && make install
cd /usr/src/releasetools
make do-hdboot

echo "Rebooting. You can exit with Ctrl+C"
reboot
EOF
```
#### Footnote
Workflow inspired by *LAB 1 minix_source.tar.xz* on the [SO2021 lab website](https://www.mimuw.edu.pl/~mb346851/SO2021/).
