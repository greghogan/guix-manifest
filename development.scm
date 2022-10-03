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
 (gnu packages base)
 (gnu packages commencement))

(include "command-line.scm")

(define development-packages
  (concatenate-manifests
   (list
    (specifications->manifest
     '(;; Build tools
       "cmake"
       "make"
       "ninja"
       "pkg-config"

       ;; Debuggers
       "gdb"
       "lldb"

       ;; C++ compilers
       "clang-toolchain"
       ;; gcc-toolchain is in the packages->manifest.

       ;; C++ libraries
       "apache-arrow"
       "cxxopts"
       "googlebenchmark"
       "googletest"
       "spdlog"

       ;; Go
       "go"

       ;; Java
       "openjdk"

       ;; Python
       "python-notebook"
       "python-wrapper"

       ;; Python libraries
       "python-networkx"
       "python-numpy"
       "python-pandas"
       "python-pyarrow"
       "python-scipy"
       "python-sympy"))
    (packages->manifest
     `(;; The included version of gcc-toolchain must match that used to build
       ;; clang-toolchain such that both compilers are usable in the profile.
       ,gcc-toolchain))
    command-line-packages)))

development-packages
