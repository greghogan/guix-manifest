#!/bin/sh

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

PACK_DIR=/volumes/nvme1n1/pack
DATE=`date +%Y%m%d`

for MANIFEST in applications command-line data-science development; do
    echo $MANIFEST

    PACK=$(./pre-inst-env guix pack \
        --format=docker \
        --compression=zstd \
        --save-provenance \
        --system=x86_64-linux \
        --relocatable --relocatable \
        --manifest=/efs/devel/guix-manifest/manifest/${MANIFEST}.scm)

    COPY=${PACK_DIR}/${DATE}-${MANIFEST}.tar.zst

    # cannot hard link to a bind mount even on the same filesystem,
    # so instead create a preferrably shallow copy
    cp --archive --reflink $PACK $COPY

    # preserve packages with a registered profile
    ./pre-inst-env guix package \
        --profile=/volumes/nvme1n1/profiles/${MANIFEST} \
        --manifest=/efs/devel/guix-manifest/manifest/${MANIFEST}.scm

    # generate tag for upload to GitHub Container Registry
    GROUP="greghogan"
    PROJECT="guix-manifest"
    VERSION=`date +%Y%m%d`
    TAG="ghcr.io/${GROUP}/${PROJECT}/${MANIFEST}:${VERSION}"

    # load image and retag
    PACK_TAG=$(echo $PACK | sed --regexp-extended 's/^[^-]*-(.*)-docker-pack.tar.zst$/\1/')

    pv $COPY | zstd --decompress --stdout | docker load
    docker tag $PACK_TAG $TAG
    docker image rm $PACK_TAG

    # upload image
    docker push $TAG
done
