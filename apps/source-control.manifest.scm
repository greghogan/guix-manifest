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
(include "../lib/target.scm")

(define source-control-packages
  (list "b4"
;        "breezy"
        "cgit"
        "cvs"
        "darcs"
        "fossil"
        "git"
        "git:gui"
        "git:send-email"
        "git:svn"
        "git-annex"
        "git-crypt"
        "git-delta"
        "git-extras"
;        "git-lfs"
        "git-sizer"
        "gitui"
        "mercurial"
        "myrepos"
        "patch"
        "patchutils"
        "pre-commit"
        "sourcetrail"
        "stgit"
        "subversion"))

(define source-control-manifest
  (package-manifest
     source-control-packages))

(with-locales source-control-manifest)
