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

(require net/url
         "http-status-code.rkt"
         "response.rkt"
         "logger.rkt")

#| If the route is not registered, this exception is thrown when trying to access. |#
(define-struct No-Handler-Found-Exn (path))

#| The structure of a route |#
(define-struct route (path function))

#| Use a global hash table to store all routing information. |#
(define DISPATCH_TABLE (make-hash))

#| return the corresponding handler according to the path. |#
(define (route/dispatch str-path)
  (let* ([url (string->url str-path)]
         [path (map path/param-path (url-path url))]
         [handler (hash-ref DISPATCH_TABLE (car path) #f)])
    (if handler
        (λ (request-info in out) (handler request-info (url-query url) in out))
        (raise (No-Handler-Found-Exn str-path)))))

#| register a handle for DISPATCH_TABLE |#
(define (route/register #:path path #:handle handle #:type type)
  (log/debug (format "register a handle on ~a with ~a" path handle))
  (hash-set! DISPATCH_TABLE
             path
             (λ (request-info query in out)
               (display (http-status-code/build-status-info 'ok) out)
               (display (response/add-type type) out)
               (handle request-info query in out))))
  

(provide route/dispatch
         route/register
         (struct-out No-Handler-Found-Exn))
