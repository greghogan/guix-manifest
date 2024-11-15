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

(include "../lib/arch.scm")
(include "../lib/locale.scm")

(define image-and-video-packages
  (append
   (match %system-architecture
     ((or "x86_64" "i686")
      (list "gimp"
            "gimp-fourier"
            "gimp-resynthesizer"))
     (_ `()))
   (list "ffmpeg"
         "imagemagick"
         "imagemagick:doc")))

(define image-and-video-manifest
  (specifications->manifest
     image-and-video-packages))

(with-locales image-and-video-manifest)
