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
commands=("qemu-img" "ssh-copy-id")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done

img_dir="$(realpath ${dir}/../images)"
cd "${img_dir}" || fail "could not cd to /images dir"

rm -f "minix.img"
qemu-img create -f qcow2 -o backing_file="${img_dir}/base_image/minix.img" minix.img || fail "could not create image"
echo "new image created"
