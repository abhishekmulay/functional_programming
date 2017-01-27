;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require rackunit)
(require 2htdp/universe)    ; needed for key=?
(require "extras.rkt")
(check-location "02" "q1.rkt")

(provide
 make-editor
 editor-pre
 editor-post
 editor?
 edit)
    
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

(define (edit ed ke)
  (cond
    [(key=? ke "\b") (delete-char ed)]
    [(key=? ke "left") (move-caret-left ed)]
    [(key=? ke "right") (move-caret-right ed)]
    [(or (key=? ke "\t") (key=? ke "\r")) (ignore ed)]
    [else (insert-at-caret ed ke)]))

;; delete-char : Editor -> Editor
;; GIVEN: An Editor with two string members "pre" and "post"
;; RETURNS: Editor where last character from its "pre" member is removed
(define (delete-char ed)
  (make-editor(remove-last-char(editor-pre ed)) (editor-post ed)))

;; insert-at-caret: Editor + KeyEvent -> Editor
(define (insert-at-caret ed char)
  (make-editor (string-append (editor-pre ed) char) (editor-post ed) ))

;; ignore: Editor -> Editor
;; Ignores any changes to Editor and returns same editor
(define (ignore ed)
  ed)

;; GIVEN: Editor with two string members "pre" and "post"
;; RETURNS: Editor with the last character of "pre" field added to that start of "post" filed
(define (move-caret-right ed)
  (make-editor
   (string-append (editor-pre ed) (get-first-char (editor-post ed)))
   (remove-first-char (editor-post ed)) ))

;; GIVEN: Editor with two string members "pre" and "post"
;; RETURNS: Editor with first character of "post" field added to start of "pre" field
(define (move-caret-left ed)
  (make-editor
   (string-append (remove-last-char (editor-pre ed)))
   (string-append (get-last-char (editor-pre ed)) (editor-post ed) )))

;; get-last-char: String -> String
;; GIVEN: String
;; RETURNS: Last character of string
(define (get-last-char string)
  (if (= (string-length string) 0) ""
      (substring string (- (string-length string) 1) (string-length string)) ))

;; get-first-char: String -> String
;; GIVEN: String
;; RETURNS: First character of string
(define (get-first-char string)
  (if (= (string-length string) 0) ""
      (substring string 0 1)))

;: remove-first-char: String -> String
;; GIVEN: String
;; RETURNS: String with first character removed
(define (remove-first-char string)
  (if (= (string-length string) 0) ""
      (substring string 1 (string-length string) )))

;; remove-last-char : String -> String
;; GIVEN: String
;; RETURNS: String with last character removed from given string

(define (remove-last-char string)
  (if (= (string-length string) 0) ""
      (substring string 0 (- (string-length string) 1) ) ))

;; TESTS:
(begin-for-test
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\b") (make-editor "Abhishe" "Mulay") " '\b' should delete last char in pre field of editor")
  (check-equal? (edit (make-editor "A" "Mulay") "\b") (make-editor "" "Mulay") " '\b' should delete last char in pre field of editor")
  (check-equal? (edit (make-editor "" "Mulay") "\b") (make-editor "" "Mulay") " '\b' should keep pre field empty")
  
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\t") (make-editor "Abhishek" "Mulay") "'\t' should be ignored")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\r") (make-editor "Abhishek" "Mulay") "'\r' should be ignored")
  
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "left") (make-editor "Abhishe" "kMulay") "For 'left' caret should move one character towards left")
  (check-equal? (edit (make-editor "A" "Mulay") "left") (make-editor "" "AMulay") "For 'left' caret should move one character towards left")
  (check-equal? (edit (make-editor "" "Mulay") "left") (make-editor "" "Mulay") "For 'left' caret should move one character towards left")
  
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "right") (make-editor "AbhishekM" "ulay") "For 'right' caret should move one character towards right")
  (check-equal? (edit (make-editor "Abhishek" "M") "right") (make-editor "AbhishekM" "") "For 'right' caret should move one character towards right")
  (check-equal? (edit (make-editor "Abhishek" "") "right") (make-editor "Abhishek" "") "For 'right' caret should move one character towards right")
  
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "a") (make-editor "Abhisheka" "Mulay") " should append alphabet to end of pre field of editor")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "1") (make-editor "Abhishek1" "Mulay") " should append number character to end of pre field of editor")
  )