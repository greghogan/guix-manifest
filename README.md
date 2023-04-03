<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

## Building the development container

A reproducible [GNU Guix](https://guix.gnu.org) Linux container can be created
with a channels file listing the source repository and commit ID as well as a
manifest file listing the set of packages to be installed.

The container can be [packaged](https://guix.gnu.org/manual/en/html_node/Invoking-guix-pack.html)
using one of several formats. To build a [Docker](https://www.docker.com) image:

```console
guix time-machine \
  --channels=channels.scm \
  -- pack \
    --format=docker \
    --compression=xz \
    --save-provenance \
    --symlink=/bin=bin \
    --symlink=/sbin=sbin \
    --system=x86_64-linux \
    --manifest=manifest/manifest.scm
```

When building and installing a simple tarball, relocatable packages can be
installed anywhere in the filesystem. The double `--relocatable` creates
"really relocatable" binaries with fallback methods when user namespaces are
not available in the kernel.

To instantiate the user environment `source gnu/store/*-profile/etc/profile`.

```console
guix time-machine \
  --channels=channels.scm \
  -- pack \
    --compression=xz \
    --save-provenance \
    --symlink=/bin=bin \
    --symlink=/sbin=sbin \
    --system=x86_64-linux \
    --relocatable --relocatable \
    --manifest=manifest/manifest.scm
```

The provided channels and manifest file were originally exported from a profile
on a running GNU Guix system but can be updated in place.

```console
guix package \
  --export-channels
```

```console
guix package \
  --export-manifest
```

The last output lines from the pack command list the derivation and output
files. The derivation file (with a '.drv' suffix) is a text file describing the
build configuration.

```console
building /gnu/store/...-cmake-make-ninja-pkg-config-gdb-lldb-docker-pack.tar.xz.drv...
/gnu/store/...-cmake-make-ninja-pkg-config-gdb-lldb-docker-pack.tar.xz
```

The container file can be loaded as a [Docker](https://www.docker.com) image.

```console
docker load < /gnu/store/...-cmake-make-ninja-pkg-config-gdb-lldb-docker-pack.tar.xz
```

## Copying packages to a remote system

Setting up the environment ...

```console
ARCH=aarch64
REMOTE=172.31.X.Y
```

A single, pre-built package can be copied.

```console
guix copy --to=$REMOTE $(guix build --dry-run /gnu/store/<hash>-<package name>.drv)
```

All packages in a profile, in all profiles, can be copied. This assumes that the
profiles are stored, as below, in this user-created directory.

```console
guix copy --to=$REMOTE $(readlink -f /var/guix/profiles/per-user/${ARCH}/*)
```

All installed builds can be copied, filtered by architecture. The regex filters
out non-built packages. This can be slow.

```console
OUTPUT=()
for DRV in /gnu/store/*.drv ; do
  if [[ $(<$DRV) =~ ${ARCH}-linux ]] ; then
    BUILD=$(guix build --dry-run $DRV 2>&1)
    if [[ $BUILD =~ ^/gnu/store/.*$ ]]; then
      OUTPUT+=($BUILD)
    fi
  fi
done
guix copy --to=$REMOTE ${OUTPUT[@]}
```

Another attempt at copying all installed builds. This is faster since the
derivation files are searched (quite inefficiently) using bash regular
expressions. This errors when attempting to copy non-built packages.

```console
TO_COPY=()
REGEX='\("[^"]*","(/gnu/store/[^"]*)"'
for DRV in /gnu/store/*.drv ; do
  echo $DRV
  if [[ $(<$DRV) =~ ${ARCH}-linux ]] ; then
    CONTENTS=$(<$DRV)
    while [[ $CONTENTS =~ $REGEX ]] ; do
      TO_COPY+=(${BASH_REMATCH[1]})

      # trim off the portion already matched
      CONTENTS="${CONTENTS#*${BASH_REMATCH[1]}}"
    done
  fi
done

guix copy --to=$REMOTE ${TO_COPY[@]}
```

## Copying the profile from a remote system

The "--system" flag to `guix build` and `guix pack` permit building and
compiling Guix packages remotely using offload builds. Unfortunately,
`guix package` has no such flag and therefore cannot be used to create profiles
for preventing package deletion during `guix gc` garbage collection. The profile
must be created on and copied from the offload host. This includes the `guix`
build for each channel and inferior.

```console
ARCH=aarch64
COMMIT=ΑΒΓΔΕΖΗΘ
REMOTE=172.31.X.Y

# copy 'current guix'
ssh $REMOTE -- guix pull --commit=$COMMIT
CURRENT_GUIX=$(ssh $REMOTE readlink -f /var/guix/profiles/per-user/${USER}/current-guix)
guix copy --from=$REMOTE $CURRENT_GUIX
sudo ln --force --no-dereference --symbolic $CURRENT_GUIX /var/guix/profiles/per-user/${ARCH}/current-guix-$COMMIT

# copy 'guix profile'
ssh $REMOTE -- /path/to/update_profile.sh
GUIX_PROFILE=$(ssh $REMOTE readlink -f .guix-profile)
guix copy --from=$REMOTE $GUIX_PROFILE
sudo ln --force --no-dereference --symbolic $GUIX_PROFILE /var/guix/profiles/per-user/${ARCH}/guix-profile
```
