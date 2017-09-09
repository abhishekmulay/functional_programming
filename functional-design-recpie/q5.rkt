;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q5) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require "extras.rkt")

;; string-remove-last: String -> String
;; GIVEN: String
;; RETURNS: Same String with last character removed
;; EXAMPLES:
;; (string-remove-last "Abhishek") = "Abhishe"
;; (string-remove-last "Design") = "Desig"
;; DESIGN STRATEGY: Combine simpler functions

;; TESTS:
(define (string-remove-last str)
  (cond [ (= (string-length str) 0) ( string-append "") ]
        [else (substring str 0 (- (string-length str) 1) )]))

(begin-for-test
  (check-equal? (string-remove-last "Abhishek") "Abhishe" "string-remove-last should remove last character of given string")
  (check-equal? (string-remove-last "a") "" "string-remove-last should remove last character of given string")
  (check-equal? (string-remove-last "a") "" "string-remove-last should remove last character of given string")
  (check-equal? (string-remove-last "") "" "string-remove-last should remove last character of given string")
  )