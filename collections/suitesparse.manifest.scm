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

(define collections-suitesparse-packages
  (list "suitesparse"
        "suitesparse-amd"
        "suitesparse-btf"
        "suitesparse-camd"
        "suitesparse-colamd"
        "suitesparse-ccolamd"
        "suitesparse-cholmod"
        "suitesparse-cxsparse"
        "suitesparse-klu"
        "suitesparse-ldl"
        "suitesparse-rbio"
        "suitesparse-mongoose"
        "suitesparse-spex"
        "suitesparse-spqr"
        "suitesparse-umfpack"))

(define collections-suitesparse-manifest
  (specifications->manifest
     collections-suitesparse-packages))

(with-locales collections-suitesparse-manifest)
