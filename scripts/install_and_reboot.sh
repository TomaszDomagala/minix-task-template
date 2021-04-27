#! /bin/bash

# Source: https://stackoverflow.com/a/24597941
function fail {
    printf '%s\n' "$1" >&2  # Send message to stderr.
    exit "${2-1}"  # Return a code specified by $2 or 1 by default.
}


# This script's directory.
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Read config file.
. "${dir}/.config"

# Required commands.
commands=("ssh")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done

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
