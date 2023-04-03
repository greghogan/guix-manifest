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

SCRIPT_DIR="$( dirname -- "${BASH_SOURCE[0]}" )"
MANIFEST="$( realpath -- ${SCRIPT_DIR}/../manifest/manifest.scm )"

MAX_JOBS="$(echo "define log2(x) { if (x == 1) return (0); return 1+log2(x/2); } ; 1+log2(`nproc`)" | bc)"

ARGUMENTS="package
    --keep-going
    --max-jobs=$MAX_JOBS
    --verbosity=1
    --manifest=$MANIFEST"

${SCRIPT_DIR}/guix_command.sh $ARGUMENTS
