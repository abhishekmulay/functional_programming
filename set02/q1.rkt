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
;; (make-editor String String)
;; INTERPRETATION:
;;   An editor is made of two parts, we consider the editor holds two strings which are separated by a virtual caret.
;;   Pre: it is the part of string which is to the left of virtual caret
;;   Post: it is the part of string which is to the right of virtual caret

;; edit : Editor + KeyEvent -> Editor 
;; GIVEN:
;;    An Editor ed with two string members "pre" and "post"
;;    A KeyEvent ke 
;; RETURNS: An Editor with changes made to the position of caret caused by the provided KeyEvent ke
;; DESIGN STRATEGY: Divide into cases based on cond



