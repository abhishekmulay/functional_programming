;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require 2htdp/universe)    ; needed for key=?
(require "extras.rkt")
      
(provide
 make-editor
 editor-pre
 editor-post
 editor?
 edit)
(check-location "02" "q1.rkt")    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; DATA DEFINITIONS:

(define-struct editor (pre post))

;; An Editor is a
;;   (make-editor String String)
;; INTERPRETATION:
;;   An editor is made of two parts, we consider the editor holds two strings which are separated by a virtual caret.
;;   Pre: it is the part of string which is to the left of virtual caret
;;   Post: it is the part of string which is to the right of virtual caret
;;
;; Observer template:
;; ------------------
;; editor-fn : Editor -> ??
;;  (define (editor-fn ed)
;;    (...
;;     (editor-pre ed)
;;       (editor-post ed)))
;;
;;
;;
;; edit : Editor + KeyEvent -> Editor
;;
;; GIVEN:
;;    An Editor ed with two string members "pre" and "post"
;;    A KeyEvent ke 
;; RETURNS: An Editor with changes made to the position of caret caused by the provided KeyEvent ke
;;
;; EXAMPLE:
;;   (edit (make-editor "Abhishek" "Mulay") "\b") = (make-editor "Abhishe" "Mulay")
;;   (edit (make-editor "Abhishek" "Mulay") "left") = (make-editor "Abhishe" "kMulay")
;;   (edit (make-editor "Abhishek" "Mulay") "right") = (make-editor "AbhishekM" "ulay")

;; DESIGN STRATEGY: Divide into cases based on cond



;; TESTS:
(begin-for-test
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\b") (make-editor "Abhishe" "Mulay") " '\b' should delete last char in pre field of editor")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\t") (make-editor "Abhishek" "Mulay") "'\t' should be ignored")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\r") (make-editor "Abhishek" "Mulay") "'\r' should be ignored")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "left") (make-editor "Abhishe" "kMulay") "For 'left' caret should move one character towards left")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "right") (make-editor "AbhishekM" "ulay") "For 'right' caret should move one character towards right")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "a") (make-editor "Abhisheka" "Mulay") " should append other character to end of pre field of editor")
)

