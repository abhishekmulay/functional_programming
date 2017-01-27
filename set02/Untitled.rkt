;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname Untitled) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require 2htdp/universe)

(define (check-key-event ke)
  (key=? ke "\t"))

;;(check-key-event "")

(define (remove-first-char string)
  (if (= (string-length string) 0) ""
      (substring string 1 (string-length string) )))

(remove-first-char "")