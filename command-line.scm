;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(use-modules
 (guix packages)
 (gnu packages base)
 (ice-9 match))

(include "locales.scm")

(define command-line-packages
  (concatenate-manifests
   (list
    (packages->manifest
     `(;; Custom locales
       ,custom-utf8-locales))
    (specifications->manifest
     (append
      (match (%current-system)
        ((or "x86_64-linux" "i686-linux")
         `("cpuid"
           "diffoscope"
           "fio"
           "ripgrep"
;           "tealdeer"
           "turbostat"))
          (_ `()))
      '(;; Compression
        "brotli"
        "bzip2"
        "gzip"
        "lz4"
        "tar"
        "xz"
        "zip"
        "zstd"

	;; Checksums
	"b3sum"
	"par2cmdline"
	"rhash"
	"ssdeep"

        ;; Documentation
        "info-reader"
        "man-db"
        "man-pages"
        "pv"
        ; tealdeer

        ;; Editors and Guix development
        "bat"
        "emacs"
        "emacs-geiser"
        "emacs-magit"
        "emacs-paredit"
        "emacs-yasnippet"
        "guile"
        "less"
        "sed"
        "vim"

        ;; Network
        "curl"
        "inetutils"
        "iperf"
        "netcat"
        "nss-certs"
        "openssh"
        "pdsh"
        "rsync"
        "socat"
        "sshpass"
        "wget"

        ;; Parsing
        "csvkit"
        ; diffoscope
        "gawk"
        "gron"
        "jq"
        "poke"
        "python-yq"
        "recutils"

        ;; Resource monitoring
        "btop"
        "htop"
        "iftop"
        "iotop"

        ;; Search
        "grep"
        ; ripgrep

        ;; Shell
        "bash"

        ;; Source control
        "colordiff"
        "diffutils"
        "git"
        "git:send-email"
        "patch"

        ;; Utilities
        "binutils"
        "coreutils"
        ; cpuid
        "dos2unix"
        "findutils"
        ; fio
        "numactl"
        "parallel"
        "procps"
        "strace"
        "time"
        "tree"
        ; turbostat
        "util-linux"
        "which"))))))

command-line-packages
