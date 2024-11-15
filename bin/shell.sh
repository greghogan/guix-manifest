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

# exit immediately on failure (even when piping), and treat unset variables and
# parameters as an error
set -euo pipefail

unset GUIX_BUILD_OPTIONS

usage() {
  echo "Usage: $0 [<guix shell args> ...] <manifest>"
}

if [ $# -lt 1 ]; then
  usage >&2
  exit 1
fi

# manifest is last arg
SHELL_ARGS=${@:1:$#-1}
MANIFEST="${@: -1}"

MANIFEST_EXTENSION=".manifest.scm"
COMMIT_EXTENSION=".commit.scm"

REALPATH="$(realpath -- $MANIFEST)"
DIRNAME="$(dirname $REALPATH)"
BASENAME="$(basename $REALPATH ${MANIFEST_EXTENSION})"

MANIFEST="${DIRNAME}/${BASENAME}${MANIFEST_EXTENSION}"
if [ ! -f $MANIFEST ]; then
    echo "Manifest file ${MANIFEST} does not exist!"
    exit 1
fi
echo "Manifest: ${MANIFEST}"

COMMIT=$(guile --no-auto-compile ${DIRNAME}/${BASENAME}${COMMIT_EXTENSION})
echo "Commit: ${COMMIT}"

guix time-machine \
  --commit="${COMMIT}" \
-- shell \
  --manifest="${MANIFEST}" \
  --keep-going \
  --verbosity=1 \
  $SHELL_ARGS
