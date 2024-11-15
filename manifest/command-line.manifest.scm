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
(include "../apps/documentation.manifest.scm")
(include "../apps/editor.manifest.scm")
(include "../apps/filesystem.manifest.scm")
(include "../apps/maintenance.manifest.scm")
(include "../apps/network.manifest.scm")
(include "../apps/parsing.manifest.scm")
(include "../apps/resource-monitoring.manifest.scm")
(include "../apps/resource-topology.manifest.scm")
(include "../apps/search.manifest.scm")
(include "../apps/shell.manifest.scm")
(include "../apps/source-control.manifest.scm")
(include "../apps/terminal.manifest.scm")
(include "../apps/utility.manifest.scm")
(include "../apps/development/editor.manifest.scm")
(include "../apps/development/javascript.manifest.scm")
(include "../apps/development/shell.manifest.scm")
(include "../apps/web/chrome.manifest.scm")
(include "../lib/arch.scm")
(include "../lib/inferior.scm")
(include "../lib/locale.scm")

(define commit
  (match %system-architecture
    ((or "x86_64" "i686")
      "c1cb7f1031c5dde2a260d8d8ad7547d6c79cc532")
    (_
      "b3d0797d279b0aa48f6b652c149b7f974f3acc89")))

(define command-line-manifest
  (concatenate-manifests
   (list
    (specifications->manifest
     (concatenate
      (list art-packages
            checksum-packages
            compression-packages
            cryptography-packages
            documentation-packages
            editor-packages
            filesystem-packages
            maintenance-packages
            network-packages
            parsing-packages
            resource-monitoring-packages
            resource-topology-packages
            search-packages
            shell-packages
            source-control-packages
            terminal-packages
            utility-packages
            development-editor-packages
            development-javascript-packages
            development-shell-packages
            web-chrome-packages)))
    (pinned-manifest
     (concatenate
      (list ))
     commit))))

(with-locales command-line-manifest)
