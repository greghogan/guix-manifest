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

;; Fix package collisions.
(use-modules
 (gnu packages pypy))

(define pypy-decollide
  (manipulate-files pypy #:remove (list "bin/python" "bin/python3" "/bin/python3.10")))

;; Listing of data science packages.
(define data-science-packages
  (concatenate-manifests
   (list
    (specifications->manifest
     (append
      ;; Packages filtered by architecture
      ;; are also included as a comment
      ;; within the package groups below.
      (match %system-architecture
        ((or "x86_64" "i686")
         `("python-jupytext"
           "python-nbdime"
           "python-notebook"))
        (_ `()))
      (list
        ;; Data Mining
;        "orange"

        ;; Julia
        "julia"

        ;; Machine Learning
        "python-keras"
        "python-pytorch"
        "tensorflow"
 
        ;; Perl
        "perl"
 
        ;; Python
        #| pypy |#
        "python-anyio"
        "python-ipython"
        "python-mypy"
        "python-setuptools"
        "python-wrapper"
 
        ;; Python notebooks
        #| python-jupytext |#
        #| python-nbdime |#
        #| python-notebook |#
 
        ;; Python libraries
        "python-duckdb"
        "python-faker"
        "python-matplotlib"
        "python-networkx"
        "python-numba"
        "python-numpy"
        "python-pandas"
        "python-pyarrow"
        "python-requests"
        "python-scikit-learn"
        "python-scikit-learn-extra"
        "python-scipy"
        "python-seaborn"
        "python-sympy"
 
        ;; Query engine
        "duckdb"

        ;; R
        "r"
        "r-igraph"
 
        ;; Ruby
        "ruby")))
    (packages->manifest
     `(;; Packages removing or renaming colliding files.
       ,pypy-decollide)))))

(with-locales data-science-packages)
