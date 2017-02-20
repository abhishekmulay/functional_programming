;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "05" "q2.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           SYSTEM GOAL                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Design a system for checking if Flapjacks fit inside Skillets
;; Refactor using generalization and use Higher Order Functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Flapjacks and Skillets                              ;; 
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
;;     (make-flapjack Real Real PosReal)

;; INTERPRETATION:
;; -- A Flapjacks is a pancake, usually served at breakfast
;; -- x : x cooordinate of the center of Flapjack
;; -- y : y cooordinate of the center of Flapjack
;; -- radius: radius of the Flapjack

;; EXAMPLES:
;;  (make-flapjack 0 0 10) = (make-flapjack 0 0 10)
;;  (make-flapjack -5 5 10) = (make-flapjack -5 5 10)

;; OBSERVER TEMPLATE:
;; flapjack-fn : Flapjack -> ??
;;  (define (flapjack-fn jack)
;;    (... (flapjack-x jack) (flapjack-y jack) (flapjack-radius jack)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ListOfFlapjack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;  A ListOfFlapjack (LOF) is either
;;  -- empty                         represents the sequence with no Flapjacks
;;  -- (cons Flapjack LOF)           represents the sequence whose first element
;;                                   is Flapjack and the rest of the sequence is
;;                                   represented by LOF
;;

;; TEMPLATE:
;; lof-fn : ListOfFlapjack -> ??
;; (define (lof-fn lst)
;;   (cond
;;     [(empty? lst) ...]
;;     [else (... (first lst)
;;                (lof-fn (rest lst)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ListOfListOfFlapjack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  A ListOfListOfFlapjack (LOLOF) is either:
;;
;;  -- empty                         represents the sequence with no
;;                                   ListOfFlapjacks
;;  -- (cons ListOfFlapjack LOLOF)   represents the sequence whose first element
;;                                   is ListOfFlapjack and the rest of the
;;                                   sequence is represented by LOLOF
;;

;; TEMPLATE:
;; lolof-fn : ListOfListOfFlapjack -> ??
;; (define (lolof-fn lst)
;;   (cond
;;     [(empty? lst) ...]
;;     [else (... (first lst)
;;                (lolof-fn (rest lst)))]))

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
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
;;     OLD      ;;
;;;;;;;;;;;;;;;;;;

;; flapjacks-in-skillet : ListOfFlapjack Skillet -> ListOfFlapjack
;; GIVEN: a list of Flapjacks and a skillet
;; RETURNS: a list of the given Flapjacks that fit entirely within the skillet
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
;(define (flapjacks-in-skillet jack-list skill)
;  (cond
;    [(empty? jack-list) empty]
;    [(fits? (first jack-list) skill)
;     (cons (first jack-list) (flapjacks-in-skillet (rest jack-list) skill))]
;    [else (flapjacks-in-skillet (rest jack-list) skill)]))

;;;;;;;;;;;;;;;;;;
;;     NEW      ;;
;;;;;;;;;;;;;;;;;;

;; flapjacks-in-skillet : ListOfFlapjack Skillet -> ListOfFlapjack
;; GIVEN: a list of Flapjacks and a skillet
;; RETURNS: a list of the given Flapjacks that fit entirely within the skillet
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
;; STRATEGY: Use HOF on filter on jack-list
(define (flapjacks-in-skillet jack-list skill)
  (cond
    [(empty? jack-list) empty]
    [else (filter
           ;; lambda : Flapjack -> Flapjack
           ;; GIVEN: a Flapjack
           ;; RETURNS: the given Flapjack if it fits entirely in skill
           (lambda (fj)
             (fits? fj skill)) jack-list)]))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
;;     OLD      ;;
;;;;;;;;;;;;;;;;;;

;; find-overlapping-flapjack-list : ListOfFlapjack ListOfFlapjack ->
;;       ListOfListOfFlapjack
;; GIVEN: two lists of Flapjacks
;; RETURNS: a list of list of Flapjacks that overlap each other
;; Flapjacks in the given list that overlap with the i-th Flapjack
;; in the given list
;; EXAMPLES:
;; (find-overlapping-flapjack-list empty)  =>  empty
;;   (find-overlapping-flapjack-list
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
;; STRATEGY: Use template for ListOfFlapjacks on jack-list
;; HALTING-MEASURE: length(ListOfFlapjack)
;(define (find-overlapping-flapjack-list jack-list complete-jack-list)
;  (cond
;    [(empty? jack-list) empty]
;    [else (cons
;           (overlapping-flapjacks-for-flapjack complete-jack-list
;              (first jack-list))
;           (find-overlapping-flapjack-list
;              (rest jack-list) complete-jack-list)) ]))


;;;;;;;;;;;;;;;;;;
;;     NEW      ;;
;;;;;;;;;;;;;;;;;;

;; overlapping-flapjacks : ListOfFlapjack -> ListOfListOfFlapjack
;; GIVEN: a list of Flapjacks
;; RETURNS: a list of the same length whose i-th element is a list of the
;; Flapjacks in the given list that overlap with the i-th Flapjack
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
;; STRATEGY:Use HOF map on jack-list
(define (overlapping-flapjacks jack-list)
  (cond
    [(empty? jack-list) empty]
    [else (map
           ;; lambda : Flapjack -> Flapjack
           ;; GIVEN: a Flapjack
           ;; RETURNS: Flapjacks that overlap with given Flapjack fj
           (lambda (fj)
             (overlapping-flapjacks-for-flapjack jack-list fj)) jack-list)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
;;     OLD      ;;
;;;;;;;;;;;;;;;;;;

;; overlapping-flapjacks-for-flapjack :
;;       ListOfFlapjack Flapjack -> ListOfFlapjack
;; GIVEN: a list of Flapjacks and a Flapjack
;; RETURNS: a list Flapjacks which overlap with given Flapjack
;; EXAMPLE:
;; (define JACK-LIST (list (make-flapjack -10  2 5)
;;                        (make-flapjack  -3  0 4)
;;                        (make-flapjack   4 -2 4.6)
;;                        (make-flapjack 7.2  6 5)
;;                        (make-flapjack  20  4 4.2)))
;;
;; (define JACK (make-flapjack -10  2 5))
;;
;; (define OVERLAPPING-FLAPJACKS-FOR-JACK
;;   (list (make-flapjack -10 2 5)
;;         (make-flapjack -3 0 4)))
;;
;;  (overlapping-flapjacks-for-flapjack JACK-LIST JACK) =>
;;                 OVERLAPPING-FLAPJACKS-FOR-JACK
;; STRATEGY: Use template for Flapjack on jack and
;;           use template for ListOfFlapjack on jack-list
;; HALTING-MEASURE: length(ListOfFlapjack)
;(define (overlapping-flapjacks-for-flapjack jack-list jack)
;  (cond
;    [(empty? jack-list) empty]
;    [(overlap? jack (first jack-list))
;     (cons (first jack-list)
;           (overlapping-flapjacks-for-flapjack (rest jack-list) jack))]
;    [else (overlapping-flapjacks-for-flapjack (rest jack-list) jack)]))
;

;;;;;;;;;;;;;;;;;;
;;     NEW      ;;
;;;;;;;;;;;;;;;;;;

;; overlapping-flapjacks-for-flapjack :
;;       ListOfFlapjack Flapjack -> ListOfFlapjack
;; GIVEN: a list of Flapjacks and a Flapjack
;; RETURNS: a list Flapjacks which overlap with given Flapjack
;; EXAMPLE:
;; (define JACK-LIST (list (make-flapjack -10  2 5)
;;                        (make-flapjack  -3  0 4)
;;                        (make-flapjack   4 -2 4.6)
;;                        (make-flapjack 7.2  6 5)
;;                        (make-flapjack  20  4 4.2)))
;;
;; (define JACK (make-flapjack -10  2 5))
;;
;; (define OVERLAPPING-FLAPJACKS-FOR-JACK
;;   (list (make-flapjack -10 2 5)
;;         (make-flapjack -3 0 4)))
;;
;;  (overlapping-flapjacks-for-flapjack JACK-LIST JACK) =>
;;                 OVERLAPPING-FLAPJACKS-FOR-JACK
;;
;; STRATEGY: Use HOF filter on jack-list
(define (overlapping-flapjacks-for-flapjack jack-list jack)
  (cond
    [(empty? jack-list) empty]
    [else (filter
           ;; lambda : Flapjack -> Flapjack
           ;; GIVEN: a Flapjack
           ;; RETURNS: the given Flapjack if it overlaps
           ;;          with any other Flapjack in jack-list
           (lambda (fj)
             (overlap? fj jack)) jack-list)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
;;     OLD      ;;
;;;;;;;;;;;;;;;;;;

;; find-non-overlapping-flapjacks :
;;     ListOfFlapjack ListOfFlapjack -> ListOfFlapjack
;; GIVEN: two lists of Flapjacks
;; RETURNS: a list of the Flapjacks in the given list that
;;     do not overlap with any other Flapjacks in the list
;; EXAMPLES:
;;   (non-overlapping-flapjacks empty)  =>  empty
;;   (non-overlapping-flapjacks
;;    (list (make-flapjack -10  2 5)
;;          (make-flapjack  -3  0 4)
;;          (make-flapjack   4 -2 4.6)
;;          (make-flapjack 7.2  6 5)
;;          (make-flapjack  20  4 4.2)))
;;   =>
;;   (list (make-flapjack  20  4 4.2))
;;
;; STRATEGY: Use template for ListOfFlapjacks on jack-list   
;; HALTING-MEASURE: length(ListOfFlapjack)
;(define (find-non-overlapping-flapjacks jack-list complete-jack-list)
;  (cond
;    [(empty? jack-list) empty]
;    [(has-overlapping-flapjacks? (first jack-list) complete-jack-list)
;     (find-non-overlapping-flapjacks (rest jack-list) complete-jack-list)]
;    [else (cons
;           (first jack-list)
;           (find-non-overlapping-flapjacks
;            (rest jack-list)
;            complete-jack-list))]))

;(define (find-non-overlapping-flapjacks jack-list complete-jack-list)
;  (cond
;    [(empty? jack-list) empty]
;    [else (filter
;           (lambda (fj)
;             (not (has-overlapping-flapjacks? fj complete-jack-list)))
;           jack-list)]))

;;;;;;;;;;;;;;;;;;
;;     NEW      ;;
;;;;;;;;;;;;;;;;;;

;; non-overlapping-flapjacks : ListOfFlapjack -> ListOfFlapjack
;; GIVEN: a list of Flapjacks
;; RETURNS: a list of the Flapjacks in the given list that
;;     do not overlap with any other Flapjacks in the list
;; EXAMPLES:
;;   (non-overlapping-flapjacks empty)  =>  empty
;;   (non-overlapping-flapjacks
;;    (list (make-flapjack -10  2 5)
;;          (make-flapjack  -3  0 4)
;;          (make-flapjack   4 -2 4.6)
;;          (make-flapjack 7.2  6 5)
;;          (make-flapjack  20  4 4.2)))
;;   =>
;;   (list (make-flapjack  20  4 4.2))
;; STRATEGY: Use HOF filter on jack-list
(define (non-overlapping-flapjacks jack-list)
  (cond
    [(empty? jack-list) empty]
    [else (filter
           ;; lambda : Flapjack -> Flapjack
           ;; GIVEN: a Flapjack
           ;; RETURNS: the given Flapjack if it does not have any
           ;;          overlapping Flapjacks
           (lambda (fj)
             (not (has-overlapping-flapjacks? fj jack-list))) jack-list)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           HELPER FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; has-overlapping-flapjacks? : Flapjack ListOfFlapjack -> Boolean
;; GIVEN: a Flapjack and a list of Flapjacks
;; RETURNS: weather given flipjack has any overlapping Flapjacks in given list
;; of Flapjacks
;; EXAMPLES:
;;   (define JACK-LIST (list (make-flapjack -10  2 5)
;;                        (make-flapjack  -3  0 4)
;;                        (make-flapjack   4 -2 4.6)
;;                        (make-flapjack 7.2  6 5)
;;                        (make-flapjack  20  4 4.2)))
;;
;;   (define JACK-IN-LIST (make-flapjack -10  2 5))
;;   (define JACK-NOT-IN-LIST (make-flapjack 20  4 4.2))
;;
;;  (has-overlapping-flapjacks? JACK JACK-IN-LIST) => true
;;  (has-overlapping-flapjacks? JACK JACK-NOT-IN-LIST) => false
;;  
;; STRATEGY: Combine simpler functions
(define (has-overlapping-flapjacks? jack jack-list)
  ( > (length (overlapping-flapjacks-for-flapjack jack-list jack)) 1))


;; overlap? : Flapjack Flapjack -> Boolean
;; GIVEN: Two flapjacks
;; RETURNS: weather the flapjacks overlap/intersect each other
;; EXAMPLE:
;;   (define JACK1 (make-flapjack -10  2 5))
;;   (define JACK2 (make-flapjack  -3  0 4))
;;   (define JACK3 (make-flapjack 20  4 4.2))
;;
;;   (overlap? JACK1 JACK2) => true
;;   (overlap? JACK1 JACK3) => false
;;
;; STRATEGY: Use template for Flapjack on jack
(define (overlap? jack1 jack2)
  ( <= (distance-sq
               (flapjack-x jack1)
               (flapjack-y jack1)
               (flapjack-x jack2)
               (flapjack-y jack2))
               (+ (flapjack-radius jack1) (flapjack-radius jack2))))

;; fits? : Flapjack Skillet -> Boolean
;; GIVEN: a Flapjack and a Skillet
;; RETURNS: whether the Flapjack fits in the given Skillet
;; EXAMPLES:
;; (fits? (make-flapjack 0 0 5)  (make-skillet 0 0 10)) = true
;; (fits? (make-flapjack 1 1 5)  (make-skillet 1 1 10)) = true
;; (fits? (make-flapjack 1 1 15)  (make-skillet 1 1 10)) = false
;; STRATEGY: Use template for Flapjack on jack and Skillet on skill

;; If distance between centers of both Flapjack and skillet is less than
;; radius of skillet then the Flapjack fits in given skillet
(define (fits? jack skill)
  ( >= (skillet-radius skill)
       (+
        (distance-sq
         (skillet-x skill) (skillet-y skill)
         (flapjack-x jack) (flapjack-y jack))
       (flapjack-radius jack))))  

;; distance-sq : Real Real Real Real -> Real
;; GIVEN: x and y coordinates of two points 
;; RETURNS: Sqaure of distance between two points
;; EXAMPLES:
;; (distance-sq 0 0 1 1) => #i1.4142135623730951
;; (distance-sq 0 0 0 0) = 0
;; STRATEGY: Combine simpler functions
(define (distance-sq x1 y1 x2 y2)
  (sqrt
   ( + (expt (- x2 x1) 2) (expt (- y2 y1) 2))))

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

(define NON-OVERLAPPING-FLAPJACKS (list (make-flapjack  20  4 4.2)))

(define EMPTY-JACK-LIST '())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TEST:

(begin-for-test

  (check-equal? (overlapping-flapjacks-for-flapjack EMPTY-JACK-LIST JACK) '()
                "should handle empty list")

  (check-equal? (non-overlapping-flapjacks EMPTY-JACK-LIST)'()
                "should handle empty list")

  (check-equal? (overlapping-flapjacks EMPTY-JACK-LIST)'()
                "should handle empty list")

  (check-equal? (flapjacks-in-skillet EMPTY-JACK-LIST "") '()
                "should handle empty list")
                 
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

  (check-equal? (flapjacks-in-skillet
                 (list (make-flapjack 10 24 6)
                       (make-flapjack 10 24 7)
                       (make-flapjack 12 30 10)
                       (make-flapjack 12 34 6)
                       (make-flapjack 17 30 5)
                       (make-flapjack 12 30 11)
                       (make-flapjack 12 35 6)
                       (make-flapjack 16.5 30 6))
                 (make-skillet 12 30 10))
                
                (list (make-flapjack 12 30 10)
                      (make-flapjack 12 34 6)
                      (make-flapjack 17 30 5))
                "flapjacks-in-skillet fails on a similar example") 

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

   (check-equal? (non-overlapping-flapjacks
                  (list (make-flapjack -10  2 5)
                        (make-flapjack  -3  0 4)
                        (make-flapjack   4 -2 4.6)
                        (make-flapjack 7.2  6 5)
                        (make-flapjack  20  4 4.2)))

                 (list (make-flapjack  20  4 4.2)))

   
   (check-equal? (fits? (make-flapjack 10 24 6) (make-skillet 12 30 10))
                 #false "should not fit")

   
   (check-equal? (fits? (make-flapjack 0 0 5) (make-skillet 0 0 10)) true
                 "should fit")
   
   (check-equal? (has-overlapping-flapjacks? JACK JACK-LIST) true)
  )
