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

;; This channel file can be passed to 'guix pull -C' or to
;; 'guix time-machine -C' to obtain the Guix revision that was
;; used to populate this profile.

;; The commit ID can be changed to either a release or rolling version.
;; Recent releases are listed in the following table.

;; Tag      Date         Commit
;; ------   --------     ----------------------------------------
;; v1.3.0   2021/05/11   a0178d34f582b50e9bdbb0403943129ae5b560ff
;; v1.2.0   2020/11/22   a099685659b4bfa6b3218f84953cbb7ff9e88063
;; v1.1.0   2020/04/14   d62c9b2671be55ae0305bebfda17b595f33797f2
;; v1.0.1   2019/05/19   d68de958b60426798ed62797ff7c96c327a672ac
;; v1.0.0   2019/05/01   6298c3ffd9654d3231a6f25390b056483e8f407c

(list
     (channel
       (name 'guix)
       (url "https://git.savannah.gnu.org/git/guix.git")
       (branch "master")
       (commit
         "a0178d34f582b50e9bdbb0403943129ae5b560ff")
       (introduction
         (make-channel-introduction
           "9edb3f66fd807b096b48283debdcddccfea34bad"
           (openpgp-fingerprint
             "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
)
