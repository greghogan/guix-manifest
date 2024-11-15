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

(define* (commit name #:optional (arch %system-architecture))
  (format #t "~a~%"
          (match arch
            ((or "x86_64" "i686")
              "0fabca25f7f798b0e88f0cf2d31c722c07c9df24")
            (_
              "6eadb7cc7b260ae1e3aa6122bd083aa2d7cc4898"))))

(apply commit (command-line))
