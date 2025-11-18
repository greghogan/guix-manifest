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

(include "../../lib/locale.scm")
(include "../../lib/target.scm")

(define development-cpp-packages
  (list ;; Build tools
        "autoconf"
        "autoconf-archive"
        "automake"
        "c++-gsl"
        "cmake"
        "cmake:doc"
        "just"
        "m4"
        "make"
        "meson"
        "ninja"
        "pkg-config"

        ;; Debuggers
        "ddd"
        "gdb"
        "lldb"
        "rr"
        "valgrind"
        "valgrind:doc"

        ;; C++ compilers
        "clang-toolchain"
        "clang-toolchain:debug"
        "cling"
        "cppcheck"
        "gcc-toolchain"
        "gcc-toolchain:debug"
        "gcc-toolchain:static"

        ;; C++ libraries
        "abseil-cpp"
        "apache-arrow"
        "apache-arrow:include"
        "apache-arrow:lib"
        "aws-sdk-cpp"
        "bloomberg-bde"
        "boost"
        "c++-gsl"
        "catch2"
        "cxxopts"
        "flint"
        "fmt"
        "folly"
        "gflags"
        "gmp"
        "gmp:debug"
        "googlebenchmark"
        "googletest"
        "gperftools"
        "kokkos"
        "nlohmann-json"
        "spdlog"
        "suitesparse"))

(define development-cpp-manifest
  (package-manifest
    development-cpp-packages))

(with-locales development-cpp-manifest)
