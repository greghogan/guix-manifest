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

# A standard Guix command (`guix [args ...]`) is run against the Guix version
# specified by `guix describe`. This script runs a Guix command using the passed
# arguments with either of two alternative methods:
# 1) locally when in a (typically git) Guix checkout
# 2) otherwise, using the version from the channels specification.

# Script arguments are simply passed through to Guix.
ARGUMENTS="$@"

SCRIPT_DIR="$( dirname -- "${BASH_SOURCE[0]}" )"
CHANNELS="$( realpath -- ${SCRIPT_DIR}/../manifest/channels.scm)"

IN_FUNCTIONAL_GUIX_REPO=0
[ -f "./pre-inst-env" ] || IN_FUNCTIONAL_GUIX_REPO=$?

IN_GUIX_DEV_ENVIRONMENT=0
[ ! -z ${GUIX_ENVIRONMENT:-} ] || IN_GUIX_DEV_ENVIRONMENT=$?

if [ $IN_FUNCTIONAL_GUIX_REPO == 0 -a $IN_GUIX_DEV_ENVIRONMENT == 0 ] ; then
  COMMAND="./pre-inst-env guix $ARGUMENTS"
elif [ $IN_FUNCTIONAL_GUIX_REPO == 0 ] ; then
  echo "in compiled guix git repo but Guix development environment not setup - run \`guix environment guix\` or \`guix shell --development guix\`"
  exit 1
elif [ $IN_GUIX_DEV_ENVIRONMENT == 0 ] ; then
  echo "in guix development but current directory not a compiled guix git repo"
  exit 1
else
  COMMAND="guix time-machine --channels=$CHANNELS -- $ARGUMENTS"
fi

echo $COMMAND
$COMMAND
