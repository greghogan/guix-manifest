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

(define development-editor-packages
  (list "codeberg-cli"
        "cwltool"
        "emacs"
        "emacs-ac-geiser"
        "emacs-debbugs"
        "emacs-emojify"
        "emacs-geiser"
        "emacs-geiser-guile"
        "emacs-guix"
        "emacs-magit"
        "emacs-markdown-mode"
        "emacs-paredit"
        "emacs-yasnippet"
        "forgejo-cli"
        "guile"
        "guile-charting"
        "guile-colorized"
        "guile-readline"
        "highlight"
        "joe"
        "meld"
        "mumi"
        "nano"
        "neovim"
        "neovim-syntastic"
        "racket"
        "reuse"
        "sbcl"
        "tree-sitter-scheme"
        "treefmt"
        "vim-airline"
        "vim-characterize"
        "vim-fugitive"
        "vim-full"
        "vim-gitgutter"
        "vim-guix-vim"
        "vim-nerdtree"
        "vim-paredit"
        "vim-scheme"
        "vim-surround"
        "xapian"))

(define development-editor-manifest
  (specifications->manifest
     development-editor-packages))

(with-locales development-editor-manifest)
