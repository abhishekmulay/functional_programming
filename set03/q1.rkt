;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
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

(define-struct world (radial-star-doodad square-doodad is-paused?))
;; A World is a (make-world Doodad Doodad Boolean)
;; radial-star-doodad is doodad
;; square-doodad is doodad
;; paused? describes whether or not the world is paused

;; template:
;; world-fn : World -> ??
;; (define (world-fn w)
;;   (... (world-cat1 w) (world-cat2 w) (world-paused? w)))

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

(define-struct radial-star-doodad (x y vx vy color))
(define-struct square-doodad (x y vx vy color))

;; EXAMPLE:
;;  (make-radial-star 10 10 5 5 "Gold")
;;  (make-radial-star 10 10 5 5 "Gold")
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
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define RADIAL-STAR "radial-star")
(define RADIAL-STAR-START-X 125)
(define RADIAL-STAR-START-Y 120)
(define SQUARE "square")
(define SQUARE-START-X 460)
(define SQUARE-START-Y 350)

(define RADIAL-STAR-IMAGE (radial-star 8 10 50 "outline" "red"))
(define SQUARE-IMAGE (square 71 "outline" "black"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; initial-world : Any -> World
;;; GIVEN: any value (ignored)
;;; RETURNS: the initial world specified for the animation
;;; EXAMPLE: (initial-world -174)
(define (initial-world v)
  (make-world
    (make-radial-star-doodad 125 120 10 12 "Gold")
    (make-square-doodad 460 350 -13 -9 "Gray")
    false))


;; world-to-scene : World -> Scene
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: (world-to-scene paused-world-at-20) should return a canvas with
;; two Doodads, one at (125, 120) and one at (460, 350)
;;          
;; STRATEGY: Use template for World on w
(define (world-to-scene w)
  (place-radial-star
    (world-radial-star-doodad w)
    (place-square
      (world-square-doodad w)
      EMPTY-CANVAS)))

;; place-radial-star : Doodad Scene -> Scene
;; RETURNS: a scene like the given one, but with the given Doodad painted
;; on it.
(define (place-radial-star star scene)
  (place-image
    RADIAL-STAR-IMAGE
    (radial-star-doodad-x star) (radial-star-doodad-y star)
    scene))

;; place-square : Doodad Scene -> Scene
;; RETURNS: a scene like the given one, but with the given Doodad painted
;; on it.
(define (place-square sq scene)
  (place-image
    SQUARE-IMAGE
    (square-doodad-x sq) (square-doodad-y sq)
    scene))


(define world-scene-at-beginning
  (place-image RADIAL-STAR-IMAGE 125 120
               (place-image SQUARE-IMAGE 460 350 EMPTY-CANVAS)))

(begin-for-test

  (check-equal? world-scene-at-beginning (world-to-scene(initial-world 12)))

  )