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

MOUNT_DIR=/volumes/nvme1n1
PACK_DIR=${MOUNT_DIR}/pack
DATE=`date +%Y%m%d`

unset GUIX_BUILD_OPTIONS

usage() {
  echo "Usage: $0 [-a|--arch <arch>] <manifest> [<manifest> ...]"
}

if [ $# -lt 1 ]; then
  usage >&2
  exit 1
fi

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--arch)
      ARCH_ARG="$2"
      shift
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

DEFAULT_ARCH="`uname -m`"
ARCH=${ARCH_ARG:-${DEFAULT_ARCH}}
echo "Arch: ${ARCH}"

MANIFEST_EXTENSION=".manifest.scm"
COMMIT_EXTENSION=".commit.scm"

for MANIFEST in "${POSITIONAL_ARGS[@]}"; do
  REALPATH="$(realpath -- $MANIFEST)"
  DIRNAME="$(dirname $REALPATH)"
  BASENAME="$(basename $REALPATH ${MANIFEST_EXTENSION})"

  MANIFEST="${DIRNAME}/${BASENAME}${MANIFEST_EXTENSION}"
  if [ ! -f $MANIFEST ]; then
    echo "Manifest file ${MANIFEST} does not exist!"
    exit 1
  fi
  echo "Manifest: ${MANIFEST}"

  COMMIT=$(guile --no-auto-compile ${DIRNAME}/${BASENAME}${COMMIT_EXTENSION} ${ARCH})
  echo "Commit: ${COMMIT}"

  PROFILE="${DIRNAME}/${BASENAME}-${ARCH}"
  SYMLINKS=""
  for DIR in "bin" "sbin"; do
    if [ -e ${PROFILE}/${DIR} ]; then
      SYMLINKS="${SYMLINKS} --symlink=/${DIR}=${DIR}"
    fi
  done

  PACK=$(guix time-machine \
    --commit="${COMMIT}" \
  -- pack \
    --manifest="${MANIFEST}" \
    --system="${ARCH}-linux" \
    --relocatable --relocatable \
    --compression=zstd \
    --save-provenance \
    $SYMLINKS \
    --keep-going \
    --verbosity=1)

  COPY=${PACK_DIR}/${DATE}-${COMMIT:0:8}-${BASENAME}.tar.zst

  # cannot hard link to a bind mount even on the same filesystem,
  # so instead create a preferrably shallow copy
  cp --archive --reflink ${MOUNT_DIR}/${PACK} $COPY
done
