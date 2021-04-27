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
commands=("rsync")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done

cd "${dir}/../sources/task" || fail "could not cd to /sources/task dir"
rsync -uav -e "ssh -p ${ssh_port}" --exclude=".git" ./usr/include/ root@localhost:/usr/include/
rsync -uav -e "ssh -p ${ssh_port}" --exclude=".git" ./usr/src/ root@localhost:/usr/src/

cd "${dir}/../"
rsync -uav -e "ssh -p ${ssh_port}" --exclude=".git" ./tests root@localhost:/

echo "sync done"