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
  echo "Usage: $0 [-a|--arch <arch>] [-c|--cores <cores] [-j|--jobs <max jobs>] <manifest> [<manifest> ...]"
}

if [ $# -lt 1 ]; then
  usage >&2
  exit 1
fi

POSITIONAL_ARGS=()
BACKUP=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -a|--arch)
      ARCH_ARG="$2"
      shift
      shift
      ;;
    -b|--backup)
      BACKUP=true
      shift
      ;;
    -c|--cores)
      CORES_ARG="$2"
      shift
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -j|--jobs)
      JOBS_ARG="$2"
      shift
      shift
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

DEFAULT_CORES=0
CORES=${CORES:-${DEFAULT_CORES}}
echo "Cores: ${CORES}"

DEFAULT_JOBS="$(echo "define log2(x) { if (x == 1) return (0); return 1+log2(x/2); } ; 1+log2(`nproc`)" | bc)"
JOBS=${JOBS_ARG:-${DEFAULT_JOBS}}
echo "Jobs: ${JOBS}"

MANIFEST_EXTENSION=".manifest.scm"
COMMIT_EXTENSION=".commit.scm"

for MANIFEST in "${POSITIONAL_ARGS[@]}"; do
  REALPATH="$(realpath -- $MANIFEST)"
  DIRNAME="$(dirname $REALPATH)"
  BASENAME="$(basename $REALPATH $MANIFEST_EXTENSION)"

  MANIFEST="${DIRNAME}/${BASENAME}${MANIFEST_EXTENSION}"
  if [ ! -f $MANIFEST ]; then
      echo "Manifest file ${MANIFEST} does not exist!"
      exit 1
  fi
  echo "Manifest: ${MANIFEST}"

  COMMIT=$(guile --no-auto-compile ${DIRNAME}/${BASENAME}${COMMIT_EXTENSION} ${ARCH})
  echo "Commit: ${COMMIT}"

  PROFILE="${DIRNAME}/${BASENAME}-${ARCH}"
  PROFILE_BACKUP="${PROFILE}.BACKUP"
  PROFILE_PACKAGE="${PROFILE}-package"

  if [ $BACKUP = true ]; then
    if [ -e "$PROFILE" ]; then
      rm -f "${PROFILE_BACKUP}"
      mv "$PROFILE" "${PROFILE_BACKUP}"
    fi
  else
    rm -f "$PROFILE"
  fi
  
  # build with '--root' registers the garbage collector root, whereas package
  # with '--profile' creates and registers enumerated profiles with symlinks
  
  guix build \
    hello \
    --root="${PROFILE}" \
    --keep-going \
    --quiet \
  | xargs guix package \
    --profile="${PROFILE_PACKAGE}" \
    --install 2>/dev/null

  if [ $? -eq 0 ]; then
    rm -f "$PROFILE" "${PROFILE_PACKAGE}"*

    guix time-machine \
      --commit="${COMMIT}" \
    -- build \
      --manifest="${MANIFEST}" \
      --max-jobs=$JOBS \
      --cores=$CORES \
      --keep-going \
      --verbosity=1 \
      --system="${ARCH}-linux" \
    | xargs guix package \
      --profile="${PROFILE_PACKAGE}" \
      --install

    if [ $? -eq 0 ]; then
      ln -s "$(readlink -f ${PROFILE_PACKAGE})" "$PROFILE"
      rm -f "$PROFILE_PACKAGE" "${PROFILE_PACKAGE}-"* "${PROFILE_BACKUP}"
    fi
  fi
done
