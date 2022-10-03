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

```console
guix time-machine \
  --channels=channels.scm \
  -- pack \
    --format=docker \
    --compression=xz \
    --save-provenance \
    --symlink=/bin=bin \
    --symlink=/sbin=sbin \
    --symlink=/usr/bin=bin \
    --symlink=/usr/sbin=sbin \
    --system=x86_64-linux \
    --manifest=development.scm
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
