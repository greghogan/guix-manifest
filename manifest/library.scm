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
 (gnu packages)
 (ice-9 popen)
 (ice-9 rdelim))

(define %system-architecture
  (let* ((port (open-input-pipe "uname --machine"))
         (str  (read-line port)))
    (close-pipe port)
    str))

;; Lookup and return package if it exists, else return alternative.
;; Example usage: "(exists-else package-name-next package-name)".
(define (exists-else package alternative)
  (cond ((not (null? (find-packages-by-name package))) package)
        (else alternative)))

;; Remove or rename (by appending the package name) files in an installed
;; package. This is designed to handle file collisions where multiple packages
;; share files with the same path, typically an issue with executables in /bin.
(use-modules
 (guix packages))

(define* (manipulate-files parent-package #:optional #:key (remove '()) (rename '()))
  (package/inherit parent-package
    (arguments
     (substitute-keyword-arguments (package-arguments parent-package)
       ((#:phases phases #~%standard-phases)
         #~(modify-phases #$phases
             (add-after 'install 'manipulate-files
               (lambda* (#:key outputs #:allow-other-keys)
                 (let ((out #$output) (name #$(package-name parent-package)))
                   (for-each
                     (lambda (file)
                       (delete-file (string-append out "/" file)))
                     '#$remove)
                   (for-each
                     (lambda (file)
                       (rename-file (string-append out "/" file)
                                    (string-append out "/" file "-" name)))
                     '#$rename))))))))))

;; Pin old versions of failing or long-running updates.
(use-modules
 (guix channels)
 (guix inferior)
 (guix utils)
 (ice-9 match))

(define %pinned-inferior-channels
  (list
   (channel
     (name 'guix)
     (url "https://git.savannah.gnu.org/git/guix.git")
     (branch "master")
     (commit
       (match %system-architecture
         ((or "x86_64" "i686")
           "7b5c030684020282a690322b558f86718eb148a7")
         (_
           "b3d0797d279b0aa48f6b652c149b7f974f3acc89")))
     (introduction
       (make-channel-introduction
         "9edb3f66fd807b096b48283debdcddccfea34bad"
         (openpgp-fingerprint
           "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))))

(define (pinned-version name)
  (car (lookup-inferior-packages (inferior-for-channels %pinned-inferior-channels) name)))
