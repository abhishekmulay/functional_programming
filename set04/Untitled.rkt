;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Untitled) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;
;;(define-struct book (title author))
;;
;;(define book1 (make-book "Mockingbird" "Abhishek"))
;;(define book2 (make-book "Vyakti aani Valli" "PuLa"))
;;(define book3 (make-book "AsamiAsami" "PuLa"))
;;
;;(cons book1 empty)
;;(cons book2 (cons book1 empty))
;;(define lst (cons book3 (cons book2 (cons book1 empty))))
;;
;;(empty? lst)
;;(first lst)
;;(rest lst)
;
;;(rest empty)
;
;;(define (test t)
;;(if ( > t 2)
;;    (cond
;;      [(= t 3) (string-append "it is 3")]
;;      [(= t 4) (string-append "it is 4")]
;;      [(= t 5) (string-append "it is 5")]
;;      [else (string-append "weird shit happened")])
;;    (string-append "in else")))
;;
;;(test 2)
;;(test 3)
;;(test 4)
;;(test 5)
;;(test 0)
;;(test 10)
;
;
;
;;; Template:
;;; ;; list-fn : ListOfX -> ??
;;; (define (list-fn lst)
;;;   (cond
;;;     [(empty? lst) ...]
;;;     [else (... (first lst)
;;;                (list-fn (rest lst)))]))
;
;;; lon-length : ListOfNumber -> Number
;;; GIVEN: a ListOfNumber
;;; RETURNS: its length
;;; EXAMPLES:
;;; (lon-length empty) = 0
;;; (lon-length (cons 11 empty)) = 1
;;; (lon-length (cons 33 (cons 11 empty))) = 2
;;; STRATEGY: Use template for ListOfNumber on lst
;
;(define (lon-length lst)
;  (cond
;    [(empty? lst) 0]
;    [else (+ 1 (lon-length (rest lst)))]))
;
;(lon-length (list 0 1 2 3 4 5))
;
;
;
;;; lon-sum : LON -> Number
;;; GIVEN: a list of numbers
;;; RETURNS: the sum of the numbers in the list
;;; EXAMPLES:
;;; (lon-sum empty) = 0
;;; (lon-sum (cons 11 empty)) = 11
;;; (lon-sum (cons 33 (cons 11 empty))) = 44
;;; (lon-sum (cons 10 (cons 20 (cons 3 empty)))) = 33
;;; STRATEGY: Use template for LON on lst
;
;(define (lon-sum lst)
;  (cond
;    [(empty? lst) 0]
;    [else (+ (first lst) (lon-sum (rest lst)))]))
;
;(lon-sum (list 0 1 2 3 4 5))
;
;
;;; double-all : LON -> LON
;;; GIVEN: a LON,
;;; RETURNS: a list just like the original, but
;;; with each number doubled
;;; EXAMPLES:
;;; (double-all empty) = empty
;;; (double-all (cons 11 empty))
;;; = (cons 22 empty)
;;; (double-all (cons 33 (cons 11 empty)))
;;; = (cons 66 (cons 22 empty))
;;; STRATEGY: Use template for LON on lst
;
;(define (double-all lst)
;  (cond
;    [(empty? lst) '()]
;    [else ( cons (* 2 (first lst)) (double-all (rest lst)) )]))
;
;(double-all (list 0 1 2 3 4 5))
;
;
;;; remove-evens : LOI -> LOI
;;; GIVEN: a LOI,
;;; RETURNS: a list just like the original, but with all the
;;; even numbers removed
;;; EXAMPLES:
;;; (remove-evens empty) = empty
;;; (remove-evens (cons 12 empty)) = empty
;;; (define list-22-11-13-46-7
;;; (cons 22 (cons 11 (cons 13 (cons 46 (cons 7 empty))))))
;;; (remove-evens list-22-11-13-46-7)
;;; = (cons 11 (cons 13 (cons 7 empty)))
;;; STRATEGY: Use template for LOI on lst
;

(define (remove-evens lst)
  (cond
    [(empty? lst) '()]
    [(even? (first lst)) (remove-evens (rest lst))]
    [else (cons (first lst) (remove-evens (rest lst)) )]))
;               
;(remove-evens (list 0 1 2 3 4 5))
;
;;;
;;; remove-first-even : LOI -> LOI
;;; GIVEN: a LOI,
;;; RETURNS: a list just like the original, but with all the
;;; even numbers removed
;;; EXAMPLES:
;;; (remove-first-even empty) = empty
;;; (remove-first-even (cons 12 empty)) = empty
;;; (define list-22-11-13-46-7
;;; (cons 22 (cons 11 (cons 13 (cons 46 (cons 7 empty))))))
;;; (remove-first-even list-22-11-13-46-7)
;;;  = (cons 11 (cons 13 (cons (cons 46 (cons 7 empty))))))
;;; STRATEGY: Use template for LOI on lst
;

(define (remove-first-even lst)
  (cond
    [(empty? lst) '()]
    [(even? (first lst)) (rest lst)]
    [else (cons (first lst) (remove-first-even (rest lst)))]))

(remove-first-even (list 1 2 3 4 5))

;
;
;
;
;
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;
;(require rackunit)
;(require "extras.rkt")
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; DATA DEFINITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;; Book
;
;(define-struct book (author title on-hand price))
;
;;; A Book is a 
;;;  (make-book String String NonNegInt NonNegInt)
;;; Interpretation:
;;; author is the author’s name
;;; title is the title
;;; on-hand is the number of copies on hand
;;; price is the price in USD
;
;;; book-fn : Book -> ??
;;; (define (book-fn b)
;;;   (... (book-author b) (book-title b) (book-on-hand b) (book-price b)))
;
;;; ListofBooks
;
;;; A ListOfBooks (LOB) is either
;;; -- empty
;;; -- (cons Book LOB)
;
;;; lob-fn : LOB -> ??
;;; (define (lob-fn lob)
;;;   (cond
;;;     [(empty? lob) ...]
;;;     [else (...
;;;             (book-fn (first lob))
;;;             (lob-fn (rest lob)))]))
;
;;; Inventory
;
;;; An Inventory is a ListOfBooks.
;;; Interp: the list of books that the bookstore carries, IN ANY ORDER.
;
;(define lob1
;  (list
;    (make-book "Felleisen" "HtDP/1" 20 7)
;    (make-book "Wand" "EOPL" 5 50)
;    (make-book "Shakespeare" "Hamlet" 0 2)
;    (make-book "Shakespeare" "Macbeth" 0 10)))
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; FUNCTION DEFINITIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;; book-inventory-value : Book -> NonNegInt
;;; GIVEN: the inventory record for a book
;;; RETURNS: the value of the copies on hand of the given book
;;; EXAMPLE: (book-inventory-value (make-book "Felleisen" "HtDP/1" 20 7)) = 140
;;; STRATEGY: Use template for Book on b
;
;(define (book-inventory-value b)
;  (* (book-on-hand b) (book-price b)))
;
;;; TEST
;(begin-for-test
;  (check-equal?
;    (book-inventory-value (make-book "Felleisen" "HtDP/1" 20 7))
;    140
;    "value of 20 Felleisens at $7 should have been $140"))
;
;;;; SEE GUIDED PRACTICE 4.4 FOR MORE
;
;
;;; inventory-total-value: LOB -> Integer
;;; GIVEN: a LOB
;;; RETURNS: sum of prices of all the books in given LOB
;;; EXAMPLES:
;;; STRATEGY: Use template for LOB on lst
;
;(define (inventory-total-value lob)
;  (cond
;    [(empty? lob) 0]
;    [else (+ (* (book-price (first lob)) (book-on-hand (first lob))) (inventory-total-value (rest lob)) )]))
;
;;; inventory-total-value : LOB -> Number
;    ;; GIVEN: a LOB
;    ;; RETURNS: the value of all the copies on hand of all the books in the
;    ;; given LOB
;    ;; (inventory-total-value lob1) = 390
;    
;    (begin-for-test
;      (check-equal? 
;        (inventory-total-value empty)
;        0
;        "value of the empty inventory should have been 0")
;      (check-equal?
;        (inventory-total-value lob1)
;        390
;        "simple test"))
;    
;    ;; books-out-of-stock : LOB -> LOB
;    ;; GIVEN: a list of books
;    ;; RETURNS: a list of the books that are out of stock in the given LOB
;    ;; Example:
;    ;; (books-out-of-stock lob1) =
;    ;;  (list
;    ;;    (make-book "Shakespeare" "Hamlet" 0 2)
;    ;;    (make-book "Shakespeare" "Macbeth" 0 10))
;  (define (books-out-of-stock lob)
;    (cond
;      [(empty? lob) '()]
;      [(= (book-on-hand (first lob)) 0)
;       (cons (first lob) (books-out-of-stock (rest lob)))]))
;

(define nums (cons 1 2 3 4 5 6 7 8))

(define (test t)
  ())
