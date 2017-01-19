;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require "extras.rkt")

;; cvolume: Real -> Real
;; GIVEN: Length of a side of cube
;; RETURNS: Volume of the cube with given side
;; EXAMPLE:
;; (cvolume 5) = 125
;; (cvolume 10) = 1000
;; DESIGN STRATEGY: Combine simpler functions

(provide cvolume)

(define (cvolume side) (* side side side))

;; TESTS
(begin-for-test
  (check-equal? (cvolume 5) 125 "Volume of cube with side 5 units should be 125 units")
  (check-equal? (cvolume 10) 1000 "Volume of cube with side 10 units should be 1000 units")
  (check-equal? (cvolume 0) 0 "Volume of cube with side 0 units should be 0 units")
)

;;----------------------------------------------------------------------------------
;;----------------------------------------------------------------------------------

(provide csurface)

;; csurface: Real -> Real
;; GIVEN: Length of side of cube
;; RETURNS: Surface area of the cube with given length of side
;; EXAMPLES:
;; (csurface 5) = 150
;; (csurface 10) = 600
;; DESIGN STRATEGY: combine simpler functions

(define (csurface side) (* 6 side side))

;; TESTS
(begin-for-test
  (check-equal? (csurface 5) 150 "Surface area of cube with side 5 units should be 150 units")
  (check-equal? (csurface 10) 600 "Surface area of cube with side 10 units should be 600 units")
  (check-equal? (csurface 0) 0 "Surface area of cube with side 0 units should be 0 units")
)
