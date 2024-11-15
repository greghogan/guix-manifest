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
 (guix channels)
 (guix inferior)
 (guix profiles)
 (guix utils)
 (ice-9 match)
 (srfi srfi-1))

;; The main GNU Guix channel.
(define (%pinned-inferior-channels commit)
  (list
   (channel
     (name 'guix)
     (url "https://git.savannah.gnu.org/git/guix.git")
     (branch "master")
     (commit commit)
     (introduction
       (make-channel-introduction
         "9edb3f66fd807b096b48283debdcddccfea34bad"
         (openpgp-fingerprint
           "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))))

;; Return single package from given commit.
(define (pinned-version name commit)
  (car (lookup-inferior-packages (inferior-for-channels (%pinned-inferior-channels commit)) name)))

;; Return full manifest of packages from given commit.
(define (pinned-manifest packages commit)
  (packages->manifest
    (map (lambda (p)
           (pinned-version p commit))
         packages)))
