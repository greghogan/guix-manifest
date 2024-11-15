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

(define parsing-packages
  (list "catdoc"
        "colordiff"
        "csvkit"
        "csvdiff"
        "dhall"
        "diff-so-fancy"
        "diffoscope"
        "diffstat"
        "diffutils"
;        "fq"
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
;        "python-yq"
        "recutils"
        "unrtf"
        "vbindiff"
        "wdiff"
        "xpdf"
        "xsv"
        "yq"))

(define parsing-manifest
  (specifications->manifest
     parsing-packages))

(with-locales parsing-manifest)
