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
#|
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
|#
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            DATA DEFINITIONS                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct flapjack (x y radius))

;; A Flapjack is a
;;     (make-flapjack Real Real PosReal)

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

;; ListOfFlapjack

;;  A ListOfFlapjack (LOF) is either
;;  -- empty
;;  -- (cons Flapjack LOF)
;;

;; TEMPLATE:
;; lof-fn : ListOfFlapjack -> ??
;; (define (lof-fn lst)
;;   (cond
;;     [(empty? lst) ...]
;;     [else (... (first lst)
;;                (lof-fn (rest lst)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct skillet (x y radius))

;; A Skillet is a
;;     (make-skillet Real Real PosReal)

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

;; flapjacks-in-skillet : ListOfFlapjack Skillet -> ListOfFlapjack
;; GIVEN: a list of flapjacks and a skillet
;; RETURNS: a list of the given flapjacks that fit entirely within the skillet
;; EXAMPLE:
;;   (flapjacks-in-skillet
;;    (list (make-flapjack -10  2 5)
;;          (make-flapjack  -3  0 4)
;;          (make-flapjack   4 -2 4.6)
;;          (make-flapjack 7.2  6 5)
;;          (make-flapjack  20  4 4.2))
;;    (make-skillet 2 3 12))
;; =>
;;   (list (make-flapjack  -3  0 4)
;;         (make-flapjack   4 -2 4.6)
;;         (make-flapjack 7.2  6 5))
;;
;; STRATEGY: Use template for ListOfFlapjack on jack-list

(define (flapjacks-in-skillet jack-list skill)
  (cond
    [(empty? jack-list) empty]
    [(fits? (first jack-list) skill)
     (cons (first jack-list) (flapjacks-in-skillet (rest jack-list) skill))]
    [else (flapjacks-in-skillet (rest jack-list) skill)]))

;; fits? : Flapjack Skillet -> Boolean
;; GIVEN: a flapjack and a skillet
;; RETURNS: weather the flpjack fits in the given skillet
;; EXAMPLES:
;; (fits? (make-flapjack 0 0 5)  (make-skillet 0 0 10)) = true
;; (fits? (make-flapjack 1 1 5)  (make-skillet 1 1 10)) = true
;; (fits? (make-flapjack 1 1 15)  (make-skillet 1 1 10)) = false
;; STRATEGY: Use template for Flapjack on jack

;; If distance between centers of both flapjack and skillet is less than
;; radius of skillet then the flapjack fits in given skillet

(define (fits? jack skill)
  ( >= (expt (skillet-radius skill) 2)
      (distance-sq (skillet-x skill) (skillet-y skill)
                (flapjack-x jack) (flapjack-y jack))))  

;; distance-sq : Real Real Real Real -> Boolean
;; GIVEN: x and y coordinates of two points 
;; RETURNS: Sqaure of distance between two points
;; EXAMPLES:
;; (distance 0 0 5) = 
;; (distace 1 1) =
;; STRATEGY: Combine simpler functions

;; Use distance formula
(define (distance-sq x1 y1 x2 y2)
    (inexact->exact
           ( + (expt (- x2 x1) 2) (expt (- y2 y1) 2))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; overlapping-flapjacks : ListOfFlapjack -> ListOfListOfFlapjack
;; GIVEN: a list of flapjacks
;; RETURNS: a list of the same length whose i-th element is a list of the
;; flapjacks in the given list that overlap with the i-th flapjack
;; in the given list
;;
;; EXAMPLES:
;;   (overlapping-flapjacks empty)  =>  empty
;;   (overlapping-flapjacks
;;    (list (make-flapjack -10  2 5)
;;          (make-flapjack  -3  0 4)
;;          (make-flapjack   4 -2 4.6)
;;          (make-flapjack 7.2  6 5)
;;          (make-flapjack  20  4 4.2)))
;;   =>
;;   (list (list (make-flapjack -10  2 5)
;;               (make-flapjack  -3  0 4))
;;         (list (make-flapjack -10  2 5)
;;               (make-flapjack  -3  0 4)
;;               (make-flapjack   4 -2 4.6))
;;         (list (make-flapjack  -3  0 4)
;;               (make-flapjack   4 -2 4.6)
;;               (make-flapjack 7.2  6 5))
;;         (list (make-flapjack   4 -2 4.6)
;;               (make-flapjack 7.2  6 5))
;;         (list (make-flapjack  20  4 4.2)))
;;
;; STRATEGY:Use template for ListOfFlapjack on jack-list

(define (overlapping-flapjacks jack-list)
  (closure jack-list jack-list))

(define (closure jack-list complete-jack-list)
  (real-work jack-list complete-jack-list))

;; find-overlapping-flapjack-list : ListOfFlapjack ListOfFlapjack -> ListOfListOfFlapjack
;; GIVEN: two lists of flapjacks
;; RETURNS: a list of list of flapjacks that overlap each other

(define (find-overlapping-flapjack-list jack-list complete-jack-list)
  (cond
    [(empty? jack-list) empty]
    [else (cons
           (overlapping-flapjacks-for-flapjack complete-jack-list (first jack-list))
           (find-overlapping-flapjack-list (rest jack-list) complete-jack-list)) ]))

;; overlapping-flapjacks-for-flapjack :
;;       ListOfFlapjack Flapjack -> ListOfFlapjack
;; GIVEN: a list of flapjacks and a flapjack
;; RETURNS: a list flapjacks which overlap with given flapjack
;; STRATEGY: Use template for Flapjack on jack
(define (overlapping-flapjacks-for-flapjack jack-list jack)
  (cond
    [(empty? jack-list) empty]
    [(overlap? jack (first jack-list))
     (cons (first jack-list)
           (overlapping-flapjacks-for-flapjack (rest jack-list) jack))]
    [else (overlapping-flapjacks-for-flapjack (rest jack-list) jack)]))

;; overlap? : Flapjack Flapjack -> Boolean
;; GIVEN: Two flapjacks
;; RETURNS: weather the flapjacks overlap/intersect each other
;; STRATEGY: Use template for Flapjack on jack
(define (overlap? jack1 jack2)
  ( < (distance-sq
               (flapjack-x jack1)
               (flapjack-y jack1)
               (flapjack-x jack2)
               (flapjack-y jack2))
              (expt (+ (flapjack-radius jack1) (flapjack-radius jack2)) 2)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            TESTS                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS:

(define JACK-LIST (list (make-flapjack -10  2 5)
                        (make-flapjack  -3  0 4)
                        (make-flapjack   4 -2 4.6)
                        (make-flapjack 7.2  6 5)
                        (make-flapjack  20  4 4.2)))

(define JACK (make-flapjack -10  2 5))

(define OVERLAPPING-FLAPJACKS-FOR-JACK
  (list (make-flapjack -10 2 5)
        (make-flapjack -3 0 4)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(begin-for-test
  (check-equal? (flapjacks-in-skillet
                 (list (make-flapjack -10  2 5)
                       (make-flapjack  -3  0 4)
                       (make-flapjack   4 -2 4.6)
                       (make-flapjack 7.2  6 5)
                       (make-flapjack  20  4 4.2))
                 (make-skillet 2 3 12))

                (list (make-flapjack  -3  0 4)
                      (make-flapjack   4 -2 4.6)
                      (make-flapjack 7.2  6 5)))

   (check-equal? (distance-sq 0 0 10 10) 200 "should be 200")
   
   (check-equal? (fits? (make-flapjack 0 0 5) (make-skillet 0 0 10)) true
                 "should fit")

   (check-equal? (overlapping-flapjacks-for-flapjack JACK-LIST JACK)
                 OVERLAPPING-FLAPJACKS-FOR-JACK
                 "Should return list of Flapjacks that overlap given Flapjack")
   
   (check-equal? (overlapping-flapjacks
                  (list (make-flapjack -10  2 5)
                        (make-flapjack  -3  0 4)
                        (make-flapjack   4 -2 4.6)
                        (make-flapjack 7.2  6 5)
                        (make-flapjack  20  4 4.2)))

                 (list (list (make-flapjack -10  2 5)
                             (make-flapjack  -3  0 4))
                       (list (make-flapjack -10  2 5)
                             (make-flapjack  -3  0 4)
                             (make-flapjack   4 -2 4.6))
                       (list (make-flapjack  -3  0 4)
                             (make-flapjack   4 -2 4.6)
                             (make-flapjack 7.2  6 5))
                       (list (make-flapjack   4 -2 4.6)
                             (make-flapjack 7.2  6 5))
                       (list (make-flapjack  20  4 4.2))) )
    
  )

(overlapping-flapjacks
    (list (make-flapjack -10  2 5)
          (make-flapjack  -3  0 4)
          (make-flapjack   4 -2 4.6)
          (make-flapjack 7.2  6 5)
          (make-flapjack  20  4 4.2)))