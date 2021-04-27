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
commands=("ssh" "scp")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done

cd "${dir}/.." || fail "could not cd to / dir"
file="${username}.patch"

if [[ ! -f "$file" ]]; then
    fail "could not find $file. use craete_patch.sh to generate .patch file"
fi

scp -P "${ssh_port}" "./$file" "root@localhost:/" || fail "could not copy file to the machine"
ssh -p "${ssh_port}" root@localhost "cd /; patch -p1 < $file" || "could not apply changes"
