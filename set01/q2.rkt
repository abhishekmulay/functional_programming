;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require "extras.rkt")

;; string-last: NonEmptyString -> 1String
;; GIVEN: a non-empty string
;; RETURNS: 1String equal to last character in given non-empty string
;; EXAMPLES:
;; (string-last "Abhishek") = "k"
;; (string-last "Programming") = "g"

;; DESIGN STRATEGY: Combine simpler functions
(provide string-last)

(define (string-last str) (string ( string-ref str ( - (string-length str) 1) )))

;; TESTS:
(begin-for-test
  (check-equal? (string-last "Abhishek") "k" "Last character of string 'Abhishek' should be 'k'.")
  (check-equal? (string-last "Programming") "g" "Last character of string 'Programming' should be 'g'.")
  (check-equal? (string-last "a") "a" "Last character of string 'a' should be 'a'.")
)
