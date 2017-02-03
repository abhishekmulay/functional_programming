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
(define RADIAL-STAR-VX 10)
(define RADIAL-STAR-VY 12)
(define SQUARE-VX -13)
(define SQUARE-VY -9)
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
;;          two Doodads, one at (125, 120) and one at (460, 350)
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
;; RETURNS: a scene like the given one, but with the given Doodad painted on it.
(define (place-square sq scene)
  (place-image
    SQUARE-IMAGE
    (square-doodad-x sq) (square-doodad-y sq)
    scene))

;; world-after-tick : World -> World
;; GIVEN: any World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick
;; EXAMPLES: 
;; STRATEGY: Use template for world on w

(define (world-after-tick w)
  (if (world-paused? w)
    w
    (make-world
      (radial-star-doodad-after-tick (world-radial-star-doodad w))
      (square-doodad-after-tick (world-square-doodad w))
      (world-paused? w))))

;; radial-star-doodad-after-tick : Doodad -> Doodad
;; GIVEN: the state of a radial-star-doodad dood
;; RETURNS: the state of the given doodad after a tick if it were in an unpaused world.

;; examples: 
;; 
;;
;; STRATEGY: use template for Doodad on dood

(define (radial-star-doodad-after-tick dood)
    (make-radial-star-doodad
      (+ (radial-star-doodad-x dood) RADIAL-STAR-VX)
      (+ (radial-star-doodad-y dood) RADIAL-STAR-VY)
      (radial-star-doodad-vx dood)
      (radial-star-doodad-vy dood)
      (radial-star-doodad-color dood)))
  

;; square-doodad-after-tick : Doodad -> Doodad
;; GIVEN: the state of a square-doodad dood
;; RETURNS: the state of the given doodad after a tick if it were in an unpaused world.

;; examples: 
;; 
;;
;; STRATEGY: use template for Doodad on dood

(define (square-doodad-after-tick dood)
    (make-square-doodad
      (+ (square-doodad-x dood) SQUARE-VX)
      (+ (square-doodad-y dood) SQUARE-VY)
      (square-doodad-vx dood)
      (square-doodad-vy dood)
      (square-doodad-color dood)))
  


;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow the given world
;; after the given key event.
;; on space, toggle paused?-- ignore all others
;; EXAMPLES: see tests below
;; STRATEGY: Cases on whether the kev is a pause event
(define (world-after-key-event w kev)
  (if (is-pause-key-event? kev)
    (world-with-paused-toggled w)
    w))

;; world-with-paused-toggled : World -> World
;; RETURNS: a world just like the given one, but with paused? toggled
;; STRATEGY: use template for World on w
(define (world-with-paused-toggled w)
  (make-world
   (world-radial-star-doodad w)
   (world-square-doodad w)
   (not (world-paused? w))))

;; help function for key event
;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
(define (is-pause-key-event? ke)
  (key=? ke " "))

;; world-paused? : World -> Boolean
;; GIVEN: a World
;; RETURNS: true iff the World is paused
(define (world-paused? w)
  (world-is-paused? w))

;; world-doodad-star : World -> Doodad
;; GIVEN: a World
;; RETURNS: the star-like Doodad of the World
(define (world-doodad-star w)
  (world-radial-star-doodad w))

;; world-doodad-square : World -> Doodad
;; GIVEN: a World
;; RETURNS: the square Doodad of the World
(define (world-doodad-square w)
  (world-square-doodad w))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS FOR TEST:
(define world-scene-at-beginning
  (place-image RADIAL-STAR-IMAGE 125 120
               (place-image SQUARE-IMAGE 460 350 EMPTY-CANVAS)))

;; TESTS:
(begin-for-test

  (check-equal? world-scene-at-beginning (world-to-scene(initial-world 12)))

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;