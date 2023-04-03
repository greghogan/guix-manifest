#!/usr/bin/env sh

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# exit immediately on failure (even when piping), treat unset variables and
# parameters as an error, and disable filename expansion (globbing)
set -eufo pipefail

# file test operators: https://tldp.org/LDP/abs/html/fto.html

if [ "$#" -lt 1 ]; then
    # use default profile
    FROM=""
else
    # convert symbolic link to directory
    RP=$(realpath "$1")
    if [ -d "$RP" ]; then
        # use given profile
        FROM="--profile=$RP"
    else
        echo "error: $1 is not a directory or symbolic link" >&2
        exit 1
    fi
fi

guix package $FROM --list-installed \
    | cut --fields=4 \
    | xargs --no-run-if-empty --replace={} bash -c "echo {} ; guix size {} ; echo" \
    | less --quit-if-one-screen
