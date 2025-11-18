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

;; https://lists.gnu.org/archive/html/help-guix/2023-03/msg00055.html
(use-modules
 (guix packages)
 (guix profiles))

(define (package-manifest packages)
  (packages->manifest
    (map (compose list specification->package+output)
         (filter (lambda (pkg)
                   (member (or (%current-system)
                               (%current-target-system))
                           (package-transitive-supported-systems
                             (specification->package+output pkg))))
                 packages))))
