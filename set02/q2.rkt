;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require "extras.rkt")
(check-location "02" "q2.rkt")
(check-location "02" "extras.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITION:

(define-struct legal-input (char))

;; A LegalInput is (make-legal-input 1String)
;; A LegalInput is one of:
;;     'd'
;;     'e'
;;     'p'
;;     's'
;; INTERPRETATION:
;;    Self evident

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITION:

 (define-struct state (id input))

;; A State is (make-state (NonNegNumber LegalInput))
;; A State is one of:
;;  -- (make-state id input)
;; INTERPRETATION:
;;   id is a NonNegNumber identifier for the state, ex. 0, 1, 2 etc.
;;   input is a LegalInput accepted by this state
;;   According to the Finite State Automata design in file q2.jpg
;;   Start state is: 0
;;   Accepting/final states are: 2, 4, 5
;; 
;;   id: 0 accepts: d, p, s  rejects: e
;;   id: 1 accepts: d, p     rejects: e, s
;;   id: 2 accepts: d, e     rejects: s, p
;;   id: 3 accepts: d        rejects: e, p, s
;;   id: 4 accepts: -        rejects: d, e, s, p
;;   id: 5 accepts: d, e     rejects: p, s
;;
;;   State "accepts" a LegalInput means there is an outgoing path for that LegalInput from that state
;;   in the FSM diagram q2.png
;;
;;   State "rejects" a LegalInput means there is NO outgoing path for that LegalInput from that state
;;   in the FSM diagram q2.png
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
