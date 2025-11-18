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
              "9245f57207c81ced0b4780f88a97a441a86b7790")
            (_
              "86fab16adb2bacf32d72fcb0c8f236cef2bc89c5"))))

(apply commit (command-line))
