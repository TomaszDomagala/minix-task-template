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
commands=("ssh-copy-id" "ssh")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done

echo "setting up ssh key"
ssh-copy-id root@localhost -p "${ssh_port}" || fail "could not copy ssh key"

echo "installing rsync"
ssh root@localhost -p "${ssh_port}" "pkgin -y in rsync"

echo "setup done"
