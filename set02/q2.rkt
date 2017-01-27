;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require "extras.rkt")
(check-location "02" "q2.rkt")
(check-location "02" "extras.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITION:

;; A LegalInput is one of:
;; -- "d"
;; -- "e"
;; -- "p"
;; -- "s"
;; INTERPRETATION:
;;    Self-evident
;; EXAMPLE:
;;(define legal-input-d "d")
;;(define legal-input-e "e")
;;(define legal-input-p "p")
;;(define legal-input-s "s")

;; TEMPLATE:
;; li-fn : LegalInput -> ??
;;(define (li-fn li)
;;  (cond
;;    [(string=?) li "d"
;;                ...])
;;    [(string=?) li "e"
;;                ...])
;;    [(string=?) li "p"
;;                ...])
;;    [(string=?) li "s"
;;                ...]))

;; State
;; A State is a Number
;; A State is one of
;; -- -1
;; -- 0
;; -- 1
;; -- 2
;; -- 3
;; -- 4
;; -- 5
;; INTERPRETATION:
;;   According to the Finite State Automata design in file q2.jpg
;;   Start state is: 0
;;   Accepting/final states are: 2, 4, 5
;;
;;   state: -1 accepts: -       rejects: d, e, s, p
;;   state: 0 accepts: d, p, s  rejects: e
;;   state: 1 accepts: d, p     rejects: e, s
;;   state: 2 accepts: d, e     rejects: s, p
;;   state: 3 accepts: d        rejects: e, p, s
;;   state: 4 accepts: -        rejects: d, e, s, p
;;   state: 5 accepts: d, e     rejects: p, s
;;
;;   State "accepts" a LegalInput means there is an outgoing path for that LegalInput from that state
;;   in the FSM diagram q2.png
;;
;;   State "rejects" a LegalInput means there is NO outgoing path for that LegalInput from that state
;;   in the FSM diagram q2.png
;;
;; EXAMPLE:
; (define state-err -1)
; (define state-0 0)
; (define state-1 1)
; (define state-2 2)
; (define state-3 3)
; (define state-4 4)
; (define state-5 5)

;; TEMPLATE:
;; state-fn : State -> ??
;; (define (state-fn st)
;;   (cond
;;     [(= st -1)
;;      ...]
;;     [(= st 0)
;;      ...]
;;     [(= st 1)
;;      ...]
;;     [(= st 2)
;;      ...]
;;     [(= st 3)
;;      ...]
;;     [(= st 4)
;;      ...]
;;     [(= st 5)
;;      ...]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTANTS:
(define state-err -1)
(define state-0 0)
(define state-1 1)
(define state-2 2)
(define state-3 3)
(define state-4 4)
(define state-5 5)

(define legal-input-d "d")
(define legal-input-e "e")
(define legal-input-p "p")
(define legal-input-s "s")

;; initial-state : Number -> State
;; GIVEN: a number
;; RETURNS: a representation of the initial state of your machine.  The given number is ignored.
(define (initial-state st)
  st)
 
;; next-state : State LegalInput -> State
;; GIVEN: a state of the machine and a machine input
;; RETURNS: the state the machine should enter if it is in the given state and sees the given input.
;; STRATEGY: Break into cases based on state
(define (next-state st input)
  (cond
    [(= st 0) (state-0-next-state input)]
    [(= st 1) (state-1-next-state input)]
    [(= st 2) (state-2-next-state input)]
    [(= st 3) (state-3-next-state input)]
    [(= st 4) (state-4-next-state input)]
    [(= st 5) (state-5-next-state input)]
    ))

;; GIVEN: A machine input
;; RETURNS: The state machine should enter if given input is passed to state 0
;; STRATEGY: Break into cases based on LegalInput
(define (state-0-next-state input)
  ((cond
    [(string=? input legal-input-d) state-2])
    [(string=? input legal-input-e) state-err])
    [(string=? input legal-input-p) state-3])
    [(string=? input legal-input-s) state-1])))

;; GIVEN: A machine input
;; RETURNS: The state machine should enter if given input is passed to state 1
;; STRATEGY: Break into cases based on LegalInput
(define (state-1-next-state input)
  ((cond
    [(string=? input legal-input-d) state-2])
    [(string=? input legal-input-e) state-err])
    [(string=? input legal-input-p) state-3])
    [(string=? input legal-input-s) state-err])))

;; GIVEN: A machine input
;; RETURNS: The state machine should enter if given input is passed to state 2
;; STRATEGY: Break into cases based on LegalInput
(define (state-2-next-state input)
  ((cond
    [(string=? input legal-input-d) state-2])
    [(string=? input legal-input-e) state-4])
    [(string=? input legal-input-p) state-3])
    [(string=? input legal-input-s) state-err])))

;; GIVEN: A machine input
;; RETURNS: The state machine should enter if given input is passed to state 3
;; STRATEGY: Break into cases based on LegalInput
(define (state-3-next-state input)
  ((cond
    [(string=? input legal-input-d) state-5])
    [(string=? input legal-input-e) state-err])
    [(string=? input legal-input-p) state-err])
    [(string=? input legal-input-s) state-err)))

;; GIVEN: A machine input
;; RETURNS: The state machine should enter if given input is passed to state 4
;; STRATEGY: Break into cases based on LegalInput
(define (state-4-next-state input)
  ((cond
    [(string=? input legal-input-d) state-err])
    [(string=? input legal-input-e) state-err])
    [(string=? input legal-input-p) state-err])
    [(string=? input legal-input-s) state-err])))

;; GIVEN: A machine input
;; RETURNS: The state machine should enter if given input is passed to state 5
;; STRATEGY: Break into cases based on LegalInput
(define (state-5-next-state input)
  ((cond
    [(string=? input legal-input-d) state-5])
    [(string=? input legal-input-e) state-4])
    [(string=? input legal-input-p) state-err])
    [(string=? input legal-input-s) state-err])))

;; accepting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true iff the given state is a final (accepting) state

(define (accepting-state? st)
  ((= (state-id st) 2 4 5)))

;; rejecting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true iff there is no path (empty or non-empty) from the given state to an accepting state
        
(define (rejecting-state? st)
  ())     