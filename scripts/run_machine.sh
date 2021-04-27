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
commands=("qemu-system-x86_64")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done

cd "${dir}/../images" || fail "could not cd to /images dir"

qemu-system-x86_64 -curses -enable-kvm -drive file=minix.img -rtc base=localtime -net user,hostfwd=tcp::"${ssh_port}"-:22 -net nic,model=virtio -m 1024M
