;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require "extras.rkt")
(require rackunit)

;; string-insert: String PositiveInteger -> String
;; GIVEN: String and an index in corresponding string between 0 to length of string
;; RETURNS: Given string with '-' inserted at given index
(provide string-insert)

(define (string-insert str index)
  (cond [(= (string-length str) 0) (string-append "-")]
       [else (string-append  (substring str 0 index) "-" (substring str index (string-length str) ) )] )
)

;; TESTS:

(begin-for-test
  (check-equal? (string-insert "Abhishek" 4) "Abhi-shek" "string-insert should insert - at given index")
  (check-equal? (string-insert "PDP" 1) "P-DP" "string-insert should insert - at given index")
  (check-equal? (string-insert "" 1) "-" "string-insert should insert - at given index")
)

