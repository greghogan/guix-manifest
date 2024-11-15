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

# Must be logged into docker before running this script!
#
REPOSITORY="ghcr.io"
GROUP="greghogan"
# Classic token from https://github.com/settings/tokens:
# TOKEN=<token>
# echo "${TOKEN}" | docker login "$REPOSITORY" -u "$GROUP" --password-stdin 

PROJECT="guix-manifest"

usage() {
  echo "Usage: $0 <image> [<image> ...]"
}

if [ $# -lt 1 ]; then
  usage >&2
  exit 1
fi

IMAGE_EXTENSION=".image.zst"

for IMAGE in "$@"; do
  if [[ ! "$IMAGE" == *"${IMAGE_EXTENSION}" ]]; then
    echo "\"${IMAGE}\" is not a valid image path!"
    exit 1
  fi

  BASENAME=$(basename $IMAGE $IMAGE_EXTENSION)

  # Eight character date ...
  DATE=${BASENAME:0:8}

  # ... then hyphen and eight character commit ID ...
  COMMIT=${BASENAME:9:8}

  # ... then hyphen then manifest name
  MANIFEST=${BASENAME:18}

  # generate tag for upload to GitHub Container Registry
  TAG="${REPOSITORY}/${GROUP}/${PROJECT}/${MANIFEST}:${DATE}-${COMMIT}"

  # load image and parse tag
  PACK_TAG=$(pv $IMAGE | zstd --decompress --stdout | docker load | sed --regexp-extended 's/^Loaded image: (.*)$/\1/')
  
  # retag
  docker tag $PACK_TAG $TAG
  docker image rm $PACK_TAG

  # upload image
  docker push $TAG
done
