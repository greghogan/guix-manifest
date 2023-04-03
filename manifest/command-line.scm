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
 (ice-9 match))

(include "library.scm")
(include "locales.scm")

;; Package updates can be made a variant before inclusion upstream.
(use-modules
 (guix download)
 (guix utils))

;; Git
(use-modules (gnu packages version-control))
(define-public git-update
  (package
    (inherit git)
    (version "2.44.0")
    (source
     (origin
       (inherit (package-source git))
       (uri (string-append "mirror://kernel.org/software/scm/git/git-"
                           version ".tar.xz"))
       (sha256 (base32 "1qqxd3pdsca6m93lxxkz9s06xs1sq0ah02lhrr0a6pjvrf6p6n73"))))
    (native-inputs (modify-inputs (package-native-inputs git)
      (replace "git-manpages"
        `(,@(origin
           (method url-fetch)
           (uri (string-append
                 "mirror://kernel.org/software/scm/git/git-manpages-"
                 version ".tar.xz"))
           (sha256
            (base32
             "1jrzcgsf4n5y42kvg8rc3jbv1r2w7fp8qw29zj41jc2fslxyhyvp")))))))))

;; Git Annex
(use-modules (gnu packages haskell-apps))
(define git-annex-updated-git
  (package
    (inherit git-annex)
    (propagated-inputs (modify-inputs (package-propagated-inputs git-annex)
              (replace "git" git-update)))))

;; Git Extras
(use-modules (gnu packages version-control))
(define git-extras-updated-git
  (package
    (inherit git-extras)
    (propagated-inputs (modify-inputs (package-propagated-inputs git-extras)
              (replace "git" git-update)))))

;; Zstd
(use-modules (gnu packages compression))
(define-public zstd-update
  (package
    (inherit zstd)
    (version "1.5.6")
    (source
     (origin
       (inherit (package-source zstd))
       (uri (string-append "https://github.com/facebook/zstd/releases/download/"
                           "v" version "/zstd-" version ".tar.gz"))
       (sha256 (base32 "1h83si7s70jy7mcy0mv1c9mbkz66qqpawxs0zkmc3b1ayinf0acc"))))))

;; Fix broken builds with package transformations.
(use-modules
 (guix transformations))

(define transform-zig-no-tests
  (options->transformation
   '((without-tests . "zig"))))

;; Use the profile toolchain to prevent package conflict in the profile.
(use-modules
 (gnu packages benchmark)
 (gnu packages commencement))

(define phoronix-test-suite-profile-toolchain
  (package
    (inherit phoronix-test-suite)
    (propagated-inputs (list gcc-toolchain-12))))

;; Fix package collisions.
(use-modules
 (gnu packages moreutils))

(define moreutils-decollide
  (manipulate-files moreutils #:rename (list "bin/parallel")))

;; Listing of command-line packages.
(define command-line-packages
  (concatenate-manifests
   (list
    (specifications->manifest
     (append
      ;; Packages filtered by architecture
      ;; are also included as a comment
      ;; within the package groups below.
      (match %system-architecture
        ((or "x86_64" "i686")
         `("b2sum"
           "cpuid"
           "distrobox"
           "duc"
           "hwinfo"
           "strace"
           "turbostat"))
        (_ `()))
      '(;; Art
        "boxes"
        "cowsay"
        "figlet"

        ;; Checksum
        #| b2sum |#
        "b3sum"
        "par2cmdline"
        "ssdeep"

        ;; Compression
        "atool"
        "brotli"
        "bzip2"
        "cabextract"
        "gzip"
        "libarchive"
        "lz4"
        "lzfse"
        "lzip"
        "lziprecover"
        "ncompress"
        "p7zip"
        "patool"
        "pbzip2"
        "plzip"
        "python-bsdiff4"
        "pzstd"
        "tar"
        "ucl"
        "xdelta"
        "xz"
        "unrar-free"
        "zip"
        "zpaq"
        #| zstd |#

        ;; Documentation
        "info-reader"
        "man-db"
        "man-pages"
        "pinfo"
        "tealdeer"

        ;; Editors
        "aspell"
        "aspell-dict-en"
        "bat"
        "hexedit"
        "hexyl"
        "less"
        "sed"

        ;; Filesystem
        "btrfs-progs"
        "compsize"
        "ddrescue"
        "di"
        "du-dust"
        "dutree"
        "eza"
        "fd"
        "findutils"
        "fswatch"
        "fzf"
        "inotify-tools"
        "plocate"

        ;; Maintenance
        "duperemove"
        "fdupes"
        "rmlint"

        ;; Network
        "aria2"
        "bpftrace"
        "curl"
        "curl:doc"
        "inetutils"
        "iperf"
        "iputils"
        "mtr"
        "netcat"
        "nss-certs"
        "openssh"
        "pdsh"
        "rsync"
        "sipcalc"
        "socat"
        "sshpass"
        "traceroute"
        "wget"
        "wget2"

        ;; Parsing
        "catdoc"
        "colordiff"
        "csvkit"
        "csvdiff"
        "diff-so-fancy"
        "diffoscope"
        "diffstat"
        "diffutils"
        "gawk"
        "gron"
        "hdf5"
        "hex"
        "htmlq"
        "jc"
        "jq"
        "lesspipe"
        "libxls"
        "mediainfo"
        "numdiff"
        "poke"
        "poppler"
        "python-jsondiff"
        "python-jsbeautifier"
        "python-pdftotext"
        "python-yq"
        "recutils"
        "unrtf"
        "vbindiff"
        "wdiff"
        "xpdf"
        "xsv"
        "yq"

        ;; Resource monitoring
        "atop"
        "bashtop"
        "btop"
        "dstat"
        #| duc |#
        "glances"
        "htop"
        "iftop"
        "iotop"
        "iproute2"
        "jnettop"
        #| ncdu |#
        "nethogs"
        "nmon"
        "sysstat"
        "tcptrack"

        ;; Resource topology
        #| cpuid |#
        "dmidecode"
        #| hwinfo |#
        "hwloc"
        "lshw"
        "numactl"

        ;; Search
        "ack"
        "grep"
        "idutils"
        "pdfgrep"
        "perl-image-exiftool"
        "ripgrep"
        "the-silver-searcher"
        "ugrep"

        ;; Shell
        "bash"
        "bash:doc"
        "bash-completion"
        "dash"
        "fish"
        "hstr"
        "nushell"
        "oil"
        "shell-functools"
        "task-spooler"
        "tcsh"
        "xonsh"
        "zsh"

        ;; Source control
        "b4"
        "breezy"
        "cgit"
        "cvs"
        "darcs"
        "fossil"
        #| git |#
        #| git:gui |#
        #| git:send-email |#
        #| git-annex |#
        "git-crypt"
        #| git-extras |#
        "git-lfs"
        "git-sizer"
        "mercurial"
        "myrepos"
        "patch"
        "patchutils"
        "pre-commit"
        "subversion"

        ;; System testing
        "fio"
        "fio:utils"
        "flamegraph"
        "hyperfine"
        "intel-mpi-benchmarks"
        "memtester"
        "perf"
        "perf-tools"
        #| phoronix-test-suite |#
        "stress-ng"
        "sysbench"

        ;; Terminal
        "screen"
        "tmux"
        "tmuxifier"
        "tmux-plugin-continuum"
        "tmux-plugin-mem-cpu-load"
        "tmux-plugin-resurrect"
        "tmux-xpanes"
        "urlscan"

        ;; Utilities
        "ascii"
        "bc"
        "coreutils"
        "datefudge"
        "dos2unix"
        "earlyoom"
        "evtest"
        "expect"
        "fakeroot"
        "hello"
        "libfaketime"
        "mc"
        #| moreutils |#
        "multitime"
        "neofetch"
        "parallel"
        "pngcheck"
        "primesieve"
        "procps"
        "progress"
        "pv"
        "pw"
        "renameutils"
        "sharutils"
        #| strace |#
        "time"
        "tree"
        #| turbostat |#
        "units"
        "util-linux"
        "which"
        "xe"
        "zenity"

        ;; X Utilities
        "mesa-utils"
        "xclip"
        "xclock"
        "xeyes"
        "xev"
        "xfishtank"
        "xmessage"
        "xpenguins"
        "xdpyinfo"
        "xsel"
        "xsnow"
        "xwininfo")))
    (packages->manifest
     `(;; Package variants updated in this manifest.
       ,git-update
       (,git-update "gui")
       (,git-update "send-email")
       ,git-annex-updated-git
       ,git-extras-updated-git
       ,zstd-update

       ;; Modified packages.
       ,phoronix-test-suite-profile-toolchain

       ;; Packages manipulating colliding files.
       ,moreutils-decollide

       ;; Package variants with transformations.
       ,(transform-zig-no-tests (specification->package "ncdu")))))))

(with-locales command-line-packages)
