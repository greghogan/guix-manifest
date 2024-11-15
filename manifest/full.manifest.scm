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
 (guix packages)
 (srfi srfi-1))

(include "../apps/art.manifest.scm")
(include "../apps/checksum.manifest.scm")
(include "../apps/compression.manifest.scm")
(include "../apps/cryptography.manifest.scm")
(include "../apps/database.manifest.scm")
(include "../apps/documentation.manifest.scm")
(include "../apps/editor.manifest.scm")
(include "../apps/education.manifest.scm")
(include "../apps/filesystem.manifest.scm")
(include "../apps/graph.manifest.scm")
(include "../apps/hello.manifest.scm")
(include "../apps/image-and-video.manifest.scm")
(include "../apps/jupyter.manifest.scm")
(include "../apps/machine-learning.manifest.scm")
(include "../apps/maintenance.manifest.scm")
(include "../apps/maths.manifest.scm")
(include "../apps/network.manifest.scm")
(include "../apps/office.manifest.scm")
(include "../apps/parsing.manifest.scm")
(include "../apps/resource-monitoring.manifest.scm")
(include "../apps/resource-topology.manifest.scm")
(include "../apps/search.manifest.scm")
(include "../apps/shell.manifest.scm")
(include "../apps/source-control.manifest.scm")
(include "../apps/system-testing.manifest.scm")
(include "../apps/terminal.manifest.scm")
(include "../apps/tex.manifest.scm")
(include "../apps/utility.manifest.scm")
(include "../apps/web.manifest.scm")
(include "../apps/x-utility.manifest.scm")
(include "../apps/data-science/data-mining.manifest.scm")
(include "../apps/data-science/julia.manifest.scm")
(include "../apps/data-science/perl.manifest.scm")
(include "../apps/data-science/python.manifest.scm")
(include "../apps/data-science/r.manifest.scm")
(include "../apps/data-science/ruby.manifest.scm")
(include "../apps/development/clojure.manifest.scm")
(include "../apps/development/container.manifest.scm")
(include "../apps/development/cpp.manifest.scm")
(include "../apps/development/d.manifest.scm")
(include "../apps/development/documentation.manifest.scm")
(include "../apps/development/editor.manifest.scm")
(include "../apps/development/erlang.manifest.scm")
(include "../apps/development/fortran.manifest.scm")
(include "../apps/development/go.manifest.scm")
(include "../apps/development/groovy.manifest.scm")
(include "../apps/development/java.manifest.scm")
(include "../apps/development/javascript.manifest.scm")
(include "../apps/development/lua.manifest.scm")
(include "../apps/development/markup.manifest.scm")
(include "../apps/development/metrics.manifest.scm")
(include "../apps/development/nim.manifest.scm")
(include "../apps/development/pascal.manifest.scm")
(include "../apps/development/php.manifest.scm")
(include "../apps/development/prolog.manifest.scm")
(include "../apps/development/rust.manifest.scm")
(include "../apps/development/shell.manifest.scm")
(include "../apps/development/smalltalk.manifest.scm")
(include "../apps/development/v.manifest.scm")
(include "../apps/development/zig.manifest.scm")
(include "../apps/web/chrome.manifest.scm")
(include "../apps/web/firefox.manifest.scm")
(include "../lib/arch.scm")
(include "../lib/inferior.scm")
(include "../lib/locale.scm")

(define commit
  (match %system-architecture
    ((or "x86_64" "i686")
      "c1cb7f1031c5dde2a260d8d8ad7547d6c79cc532")
    (_
      "b3d0797d279b0aa48f6b652c149b7f974f3acc89")))

(define full-manifest
  (concatenate-manifests
   (list
    (specifications->manifest
     (concatenate
      (list art-packages
            checksum-packages
            compression-packages
            cryptography-packages
            database-packages
            documentation-packages
            editor-packages
            education-packages
            filesystem-packages
            graph-packages
            hello-packages
            image-and-video-packages
            jupyter-packages
            machine-learning-packages
            maintenance-packages
            maths-packages
            network-packages
            office-packages
            parsing-packages
            resource-monitoring-packages
            resource-topology-packages
            search-packages
            shell-packages
            source-control-packages
            system-testing-packages
            terminal-packages
            tex-packages
            web-packages
            utility-packages

            data-science-data-mining-packages
            data-science-julia-packages
            data-science-perl-packages
            data-science-python-packages
            data-science-r-packages
            data-science-ruby-packages

            development-clojure-packages
            development-container-packages
            development-cpp-packages
            development-d-packages
            development-documentation-packages
            development-editor-packages
            development-erlang-packages
            development-fortran-packages
            development-go-packages
            development-groovy-packages
            development-java-packages
            development-javascript-packages
            development-lua-packages
            development-markup-packages
            development-metrics-packages
            development-nim-packages
            development-pascal-packages
            development-php-packages
            development-prolog-packages
            development-rust-packages
            development-shell-packages
            development-smalltalk-packages
            development-v-packages
            development-zig-packages

            web-chrome-packages
            web-firefox-packages)))
    (pinned-manifest
     (concatenate
      (list ))
     commit))))

(with-locales full-manifest)
