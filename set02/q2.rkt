;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require "extras.rkt")
(check-location "02" "q2.rkt")
(check-location "02" "extras.rkt")


;; DATA DEFINITION:
     (define-struct legal-input (char))
     
;; A LegalInput is one of:
;;     'd'
;;     'e'
;;     'p'
;;     's'
;; INTERPRETATION:
;;    Self evident
;;
     
;; initial-state : Number -> State
;; GIVEN: a number
;; RETURNS: a representation of the initial state
;; of your machine.  The given number is ignored.
;;          
;; next-state : State LegalInput -> State
;; GIVEN: a state of the machine and a machine input
;; RETURNS: the state the machine should enter if it
;; is in the given state and sees the given input.
;;          
;; accepting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true iff the given state is a final (accepting) state
;;          
;; rejecting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true iff there is no path (empty or non-empty) from the given state to an accepting state
        
     