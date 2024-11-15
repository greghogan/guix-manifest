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

(include "../../lib/arch.scm")
(include "../../lib/locale.scm")

(define data-science-python-packages
  (append
   (match %system-architecture
     ((or "x86_64" "i686")
      (list "python-jupytext"
            "python-nbdime"
            "python-notebook"))
     (_ `()))
   (list ;; Python
         "conda"
         "pypy"
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
;         "python-numba"
         "python-numpy"
         "python-pandas"
         "python-pyarrow"
         "python-requests"
         "python-scikit-learn"
;         "python-scikit-learn-extra"
         "python-scipy"
         "python-seaborn"
         "python-sympy")))

(define data-science-python-manifest
  (specifications->manifest
     data-science-python-packages))

(with-locales data-science-python-manifest)
