;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rackever                                                                       ;;
;;                                                                                ;;
;; MIT License                                                                    ;;
;;                                                                                ;;
;; Copyright (c) 2022 muqiuhan                                                    ;;
;;                                                                                ;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy   ;;
;; of this software and associated documentation files (the "Software"), to deal  ;;
;; in the Software without restriction, including without limitation the rights   ;;
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      ;;
;; copies of the Software, and to permit persons to whom the Software is          ;;
;; furnished to do so, subject to the following conditions:                       ;;
;;                                                                                ;;
;; The above copyright notice and this permission notice shall be included in all ;;
;; copies or substantial portions of the Software.                                ;;
;;                                                                                ;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     ;;
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       ;;
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    ;;
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         ;;
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  ;;
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  ;;
;; SOFTWARE.                                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#lang racket/base

(require racket/match)

#| Unknown request info type.
|| Thrown when the info-type parameter of the get-request-info function is wrong. |#
(struct Unknow-Request-Info-Type-Exn (info-type))

#| get request info |#
(define (request/get-info in #:info-type [info-type 'header])
  (let ([header (read-line in)])
    ;; filter out eof
    (if (not (eq? header eof))
        (let* ([header (regexp-match #rx"^GET (.+) HTTP/[0-9]+\\.[0-9]+" header)]
               [rest (regexp-match #rx"(\r\n|^)\r\n" in)]
               [full (list header rest)])
          (match info-type
            ['header header]
            ['full full]
            ['rest rest]
            [_ (raise (Unknow-Request-Info-Type-Exn info-type))]))
        '())))

(provide request/get-info)
