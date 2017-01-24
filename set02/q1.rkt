;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(require "extras.rkt")
(require rackunit)
(check-location "02" "q1.rkt")

;; edit: Editor + KeyEvent -> Editor

(define-struct editor [pre post])

(define (remove-last-char string)
  (substring string 0 (- (string-length string) 1) ) )

(define (remove-first-char string)
  (substring string 1 (string-length string) ))

(define (get-last-char string)
  (substring string (- (string-length string) 1) (string-length string)) )

(define (get-first-char string)
  (substring string 0 1))

(define (move-caret-right editor)
  (make-editor
   (string-append (editor-pre editor) (get-first-char (editor-post editor)))
   (remove-first-char (editor-post editor)) ))

(define (move-caret-left editor)
  (make-editor (string-append (remove-last-char (editor-pre editor)))
               (string-append (get-last-char (editor-pre editor)) (editor-post editor) )))

(define (insert-at-caret editor char)
  (make-editor (string-append (editor-pre editor) char) (editor-post editor) ))

(define (edit editor key-event)
  (cond
    [(string=? key-event "\b") (make-editor(remove-last-char (editor-pre editor)) (editor-post editor))]
    [(or (string=? key-event "\r") (string=? key-event "\t")) editor]
    [(string=? key-event "left") (move-caret-left editor)]
    [(string=? key-event "right") (move-caret-right editor)]
    [else (insert-at-caret editor key-event)]))

(begin-for-test
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\b") (make-editor "Abhishe" "Mulay") " '\b' should delete last char in pre field of editor")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\t") (make-editor "Abhishek" "Mulay") "'\t' should be ignored")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "\r") (make-editor "Abhishek" "Mulay") "'\r' should be ignored")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "left") (make-editor "Abhishe" "kMulay") "For 'left' caret should move one character towards left")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "right") (make-editor "AbhishekM" "ulay") "For 'right' caret should move one character towards right")
  (check-equal? (edit (make-editor "Abhishek" "Mulay") "a") (make-editor "Abhisheka" "Mulay") " should append other character to end of pre field of editor")
)

