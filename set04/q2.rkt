;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "04" "q2.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                          ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide
make-flapjack
flapjack-x
flapjack-y
flapjack-radius
make-skillet
skillet-x
skillet-y
skillet-radius
overlapping-flapjacks
non-overlapping-flapjacks
flapjacks-in-skillet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            DATA DEFINITIONS                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct flapjack (x y radius))

;; A Flapjack is a
;;     (make-flapjack Integer Integer Integer)

;; INTERPRETATION:
;; --  A flapjacks is a pancake, usually served at breakfast
;; -- x : x cooordinate of the center of flapjack
;; -- y : y cooordinate of the center of flapjack
;; -- radius: radius of the flapjack

;; EXAMPLES:
;;  (make-flapjack 0 0 10) = (make-flapjack 0 0 10)
;;  (make-flapjack -5 5 10) = (make-flapjack -5 5 10)

;; TEMPLATE:
;; flapjack-fn : Flapjack -> ??
;;  (define (flapjack-fn jack)
;;    (... (flapjack-x jack) (flapjack-y jack) (flapjack-radius jack)))

(define-struct skillet (x y radius))

;; A Skillet is a
;;     (make-skillet Integer Integer Integer)

;; INTERPRETATION:
;; -- A skillet is a flat-bottomed pan used for frying, searing,
;;    and browning foods. 
;; -- x : x cooordinate of the center of skillet
;; -- y : y cooordinate of the center of skillet
;; -- radius: radius of skillet

;; EXAMPLES:
;;  (make-skillet 0 0 10) = (make-skillet 0 0 10)
;;  (make-skillet 5 5 10) = (make-skillet 5 5 10)

;; TEMPLATE:
;; skillet-fn : Skillet -> ??
;;  (define (skillet-fn skill)
;;    (.. (skilet-x skill) (skillet-y skill) (skillet-radius skill)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; contract : ->
;; GIVEN:
;; RETURNS:
;; EXAMPLES:
;; STRATEGY:


;; Template:
;; ;; list-fn : ListOfX -> ??
;; (define (list-fn lst)
;;   (cond
;;     [(empty? lst) ...]
;;     [else (... (first lst)
;;                (list-fn (rest lst)))]))
