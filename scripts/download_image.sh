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
commands=("unxz" "scp")
for c in "${commands[@]}"
do
if ! command -v "${c}" &> /dev/null
then
    fail "${c} could not be found"
fi
done


host="students.mimuw.edu.pl"
path="/home/students/inf/PUBLIC/SO/scenariusze/4/minix.img.xz"

mkdir -p "${dir}/../images/base_image"
cd "${dir}/../images/base_image"

echo "Downloading image..."
scp "${username}@${host}:${path}" "." || fail "cannot download image"

echo "Uncompressing image..."
unxz -v "minix.img.xz" || fail "cannot uncompress image"
