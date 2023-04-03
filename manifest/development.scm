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

(include "library.scm")
(include "locales.scm")

(use-modules
 (guix packages)
 (ice-9 match))

;; Package updates can be made a variant before inclusion upstream.
(use-modules
 (guix git-download)
 (guix utils))

;; CMake
(use-modules (gnu packages cmake))
(define-public cmake-update
  (package
    (inherit cmake)
    (version "3.29.1")
    (source
     (origin
       (inherit (package-source cmake))
       (uri (string-append "https://cmake.org/files/v"
                           (version-major+minor version)
                           "/cmake-" version ".tar.gz"))
       (sha256 (base32 "1k7g1smk47h26m3lk228f8iimfj80611xxscdfm3jaxnay7jxc3z"))))
    (arguments
     (substitute-keyword-arguments (package-arguments cmake)
       ((#:configure-flags flags)
        #~(cons* "-DCMake_ENABLE_DEBUGGER=OFF" #$flags))))))

;; Folly
(use-modules (gnu packages cpp))
(define-public folly-update
  (package
    (inherit folly)
    (version "2024.02.12.00")
    (source
     (origin
       (inherit (package-source folly))
       (uri (git-reference
             (url "https://github.com/facebook/folly")
             (commit (string-append "v" version))))
       (file-name (git-file-name "folly" version))
       (sha256 (base32 "055dvpj3rvhwk3lx5lkipcjr2dnbnrhw86mwsv56iwzqh9k4hiyz"))))))

;; Ninja
(use-modules (gnu packages ninja))
(define-public ninja-update
  (package
    (inherit ninja)
    (version "1.11.1")
    (source
     (origin
       (inherit (package-source ninja))
       (uri (git-reference
             (url "https://github.com/ninja-build/ninja")
             (commit (string-append "v" version))))
       (file-name (git-file-name "ninja" version))
       (sha256 (base32 "14kshkxdn833nkz2qkzb3w531dcqj6haad90gxj70ic05lb7zx9f"))))))

;; Clang Toolchain
;; clang-toolchain (as configured and compiled) can only be installed with the
;; version of gcc-toolchain used to compile clang/llvm. This typically restricts
;; gcc to a version several years old, but can be accessed by loading the
;; "(gnu packages commencement)" module and referencing ",gcc-toolchain" in the
;; packages->manifest.
;;
;; A newer version of gcc can be included using package rewriting on
;; clang-toolchain as done here. This does not always permit use of the newest
;; gcc; for example, in Guix 1.4.0 we can build with gcc@11 but glibc@2.33 fails
;; when building with gcc@12. Including the newer glibc@2.35 for core-updates is
;; not possible since package rewriting cannot be performed with an inferior,
;; and rewriting with glibc looks to simply be too large a modification and
;; results in out-of-memory errors when copying the package definition locally.
;;
;; The newest supported version of gcc for compiling glibc can be found in the
;; "Recommended Tools for Compilation" section for the appropriate version at:
;; https://sourceware.org/git/?p=glibc.git;f=INSTALL;hb=refs/tags/glibc-2.33

(use-modules
 (gnu packages gcc)
 (gnu packages llvm))

(define with-gcc12
  (package-input-rewriting/spec
   `(("gcc" . ,(const gcc-12)))))

(define clang-toolchain-with-gcc12
  (with-gcc12 clang-toolchain-17))

(define lldb-with-gcc12
  (with-gcc12 lldb))

;; Listing of development packages.
(define development-packages
  (concatenate-manifests
   (list
    (specifications->manifest
     (append
      ;; Packages filtered by architecture
      ;; are also included as a comment
      ;; within the package groups below.
      (match %system-architecture
        ((or "x86_64" "i686")
         `("bloomberg-bde"
           "maven"
           "pandoc"
           "shellcheck"))
        (_ `()))
      (list
        ;; Build tools
        "autoconf"
        "automake"
        #| cmake |#
        #| cmake:doc |#
        "just"
        "m4"
        "make"
        "meson"
        #| ninja |#
        "pkg-config"

        ;; Code
        "cloc"

        ;; Debuggers
        "ddd"
        "gdb"
        #| lldb |#
        "rr"
        "valgrind"
        "valgrind:doc"

        ;; C++ compilers
        #| clang-toolchain |#
        #| clang-toolchain:debug |#
        "cling"
        "cppcheck"
        "gcc-toolchain@12"
        "gcc-toolchain@12:debug"

        ;; C++ libraries
        "abseil-cpp"
        "apache-arrow"
        "apache-arrow:include"
        "apache-arrow:lib"
        "aws-sdk-cpp"
        #| bloomberg-bde |#
        "boost"
        "c++-gsl"
        "catch2"
        "cxxopts"
        "flint"
        "fmt"
        #| folly |#
        "gflags"
        "gmp"
        "gmp:debug"
        "googlebenchmark"
        "googletest"
        "gperftools"
        "nlohmann-json"
        "spdlog"
        "suitesparse"

        ;; Clojure
        "clojure"

        ;; Containers
        "docker-compose"

        ;; D
        "gdc-toolchain"

        ;; Documentation
        "doxygen"

        ;; Erlang
        "elixir"
        "erlang"

        ;; Fortran
        "gfortran-toolchain"

        ;; Go
        "delve"
        "go"

        ;; Groovy
        "groovy"

        ;; Java
        #| maven |#
        "openjdk"
        "openjdk:doc"
        "openjdk:jdk"

        ;; Java libraries
        "java-junit"

        ;; Javascript / Typescript
        "node"

        ;; Lua
        "lua"

        ;; Markup
        "html2text"
        "html-xml-utils"
        "latex2html"
        "markdown"
        #| pandoc |#
        "python-ansi2html"
        "tidy-html"

        ;; Nim
        "nim"

        ;; PHP
        "php"

        ;; Rust
        "rust"
        "rust:tools"
        "rust-cargo"

        ;; Shell
        #| shellcheck |#
        "shflags"

        ;; Smalltalk
        "smalltalk"
        "squeak-vm"

        ;; V
        "vlang"

        ;; Zig
        #| zig |#)))
    (packages->manifest
     `(;; The included version of gcc-toolchain must match that used to build
       ;; clang-toolchain such that both compilers are usable in the profile.
       ,clang-toolchain-with-gcc12
       (,clang-toolchain-with-gcc12 "debug")

       ;; Rewriten lldb avoids copies of dependent clang packages.
       ,lldb-with-gcc12

       ;; Package variants updated in this manifest.
       ,cmake-update
       (,cmake-update "doc")
       ,folly-update
       ,ninja-update

       ;; Package variants with transformations.
       ,(transform-zig-no-tests (specification->package "zig")))))))

(with-locales development-packages)
