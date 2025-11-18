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

(include "../lib/locale.scm")
(include "../lib/target.scm")

;; Fix package collisions.
(use-modules
 (gnu packages moreutils))

(define utility-packages
  (list "ascii"
        "bc"
        "coreutils"
        "datefudge"
        "dos2unix"
        "earlyoom"
        "evtest"
        "expect"
        "fakeroot"
        "libfaketime"
        "libtree"
        "mc"
        "moreutils"
        "multitime"
        "neofetch"
        "parallel"
        "pngcheck"
        "primesieve"
        "procps"
        "progress"
        "psmisc"
        "pv"
        "pw"
        "pwgen"
        "renameutils"
        "sharutils"
        "strace"
        "time"
        "tree"
        "turbostat"
        "units"
        "util-linux"
        "which"
        "xe"
        "zenity"))

(define utility-manifest
  (package-manifest
     utility-packages))

(with-locales utility-manifest)
