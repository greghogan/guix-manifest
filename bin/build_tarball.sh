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

SCRIPT_DIR="$( dirname -- "${BASH_SOURCE[0]}" )"
MANIFEST="$( realpath -- ${SCRIPT_DIR}/../manifest/manifest.scm )"

ARGUMENTS="pack
    --compression=zstd
    --save-provenance
    --symlink=/bin=bin
    --symlink=/sbin=sbin
    --system=x86_64-linux
    --relocatable --relocatable
    --manifest=${MANIFEST}"

${SCRIPT_DIR}/guix_command.sh $ARGUMENTS
