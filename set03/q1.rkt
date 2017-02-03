;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "03" "q1.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; two draggable doodads.
;; There are two doodads. They are individually draggable.
;; But space pauses or unpauses the entire system.

;; starts with (animation 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; A Doodad is:
;; -- (make-doodad type x y vx vy color)
;; INTERPRETATION:
;;   type: type is one of "radial-star" or "square"
;;   x: x-coordinate of Doodad
;;   y: x-coordinate of Doodad
;;   vx: number of pixels the Doodad moves on each tick in the x direction
;;   vy: number of pixels the Doodad moves on each tick in the y direction
;;   color: current color of this doodad

;; A Doodad is one of
;;
;; -- (make-radial-star-doodad color)
;; INTERPRETATION:
;;   colors: is the possible colors for this Doodad
;;
;; -- (make-square-doodad color)
;; INTERPRETATION:
;;   colors: is the possible colors for this Doodad

;; TEMPLATE:
;; doodad-fn : Cat -> ??
;; (define (doodad-fn c)
;;  (... (doodad-type w) (doodad-x w) (doodad-y w) (doodad-vx w) (doodad-vy w)))

;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn dood)
;;   (cond
;;     [(radial-star? dood) ...]
;;     [(square? dood)...]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS:
(define CANVAS-WIDTH 450)
(define CANVAS-HEIGHT 400)
(define EMPY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define RADIAL-STAR "radial-star")
(define SQUARE "square")
