;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define TICKET-BASE-PRICE 5.0)
(define ATTENDEE-BASE-SIZE 120)
(define PERFORMANCE-FIZED COST 180)
(define AVERAGE-ATTANDANCE-CHANGE 15)
(define COST-PER-ATTENDEE 0.04)
(define MINIMUM-PRICE-CHANGE 0.1)


(define (attendees ticket-price)
  (- ATTENDEE-BASE-SIZE (* (- ticket-price TICKET-BASE-PRICE) (/ AVERAGE-ATTANDANCE-CHANGE MINIMUM-PRICE-CHANGE))))

(define (revenue ticket-price)
  (* ticket-price (attendees ticket-price)))

(define (cost ticket-price)
  (+ PERFORMANCE-FIZED (* COST-PER-ATTENDEE (attendees ticket-price))))

(define (profit ticket-price)
  (- (revenue ticket-price)
     (cost ticket-price)))
