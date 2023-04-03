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

;; Package updates can be made a variant before inclusion upstream.
(use-modules
 (guix git-download)
 (guix packages)
 (guix utils))

(use-modules (gnu packages tex))
(define-public texstudio-update
  (package
    (inherit texstudio)
    (version "4.7.3")
    (source
     (origin
       (inherit (package-source texstudio))
       (uri (git-reference
             (url "https://github.com/texstudio-org/texstudio")
             (commit version)))
       (file-name (git-file-name (package-name texstudio) version))
       (sha256
        (base32
         "0y68mqi6fzrpb4p525wpcqgnv9hwadj6ps6prrwpknvba678s2w4"))))))

;; Listing of application packages.
(define applications-packages
  (concatenate-manifests
   (list
    (specifications->manifest
     (append
      ;; Packages filtered by architecture
      ;; are also included as a comment
      ;; within the package groups below.
      (match %system-architecture
        ((or "x86_64" "i686")
         `("gimp"
           "gimp-fourier"
           "gimp-resynthesizer"))
        (_ `()))
      '(;; Cryptography
        "gnupg"
        "paperkey"

        ;; Database
        "mariadb"
        "postgresql"
        "sqlite"

        ;; Editors and Guix development
        "cwltool"
        "emacs"
        "emacs-ac-geiser"
        "emacs-debbugs"
        "emacs-geiser"
        "emacs-geiser-guile"
        "emacs-magit"
        "emacs-paredit"
        "emacs-yasnippet"
        "guile"
        "guile-charting"
        "guile-colorized"
        "guile-readline"
        "joe"
        #| libreoffice |#
        "meld"
        "mumi"
        "nano"
        "neovim"
        "neovim-syntastic"
        "racket"
        "sbcl"
        "tree-sitter-scheme"
        "vim-airline"
        "vim-characterize"
        "vim-fugitive"
        "vim-full"
        "vim-gitgutter"
        "vim-nerdtree"
        "vim-surround"

        ;; Education
        "anki"

        ;; Graph
        "graphviz"
        "graphviz:doc"
        "igraph"
        "python-graph-tool"
        "python-igraph"

        ;; Image Processing
        #| gimp |#
        #| gimp-resynthesizer |#
        #| gimp-fourier |#
        "imagemagick"
        "imagemagick:doc"

        ;; TeX
        "texlive-scheme-basic"
        "texlive-datetime2"
        #| texstudio |#

        ;; Maths
        "giac"
        "gnuplot"
        "nickle"
        "octave-cli"
        "scilab"

        ;; Video
        "ffmpeg"

        ;; Web
        #| icecat |#
        "lynx"
        "ublock-origin-chromium"
        #| ungoogled-chromium |#
        "w3m")))
    (packages->manifest
     `(;; Package variants updated in this manifest.
       ,texstudio-update

       ;; Packages with pinned verions.
       ,(pinned-version "icecat")
       ,(pinned-version "libreoffice")
       ,(pinned-version "ungoogled-chromium"))))))

(with-locales applications-packages)
