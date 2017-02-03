;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
;; radial-star-doodad is Doodad
;; square-doodad is Doodad
;; is-paused? describes whether or not the world is paused

;; template:
;; world-fn : World -> ??
;; (define (world-fn w)
;;   (... (world-radial-star-doodad w) (world-square-doodad w) (world-is-paused? w)))

(define-struct doodad (type x y vx vy color representation))
;; A Doodad is:
;; -- (define-struct doodad (String Int Int Int Int IMAGE))
;; INTERPRETATION:
;;   type: type is one of "radial-star" or "square"
;;   x: x-coordinate of Doodad
;;   y: x-coordinate of Doodad
;;   vx: number of pixels the Doodad moves on each tick in the x direction
;;   vy: number of pixels the Doodad moves on each tick in the y direction
;;   color: color of this Doodad
;;   representation: visual representation of Doodad, it is an Image

;; EXAMPLE:
;;  (make-doodad "radial-star" 10 10 5 5 (radial-star 8 10 50 "outline" color))
;;  (make-doodad "square" 10 10 5 5 (square 71 "outline" color))
;;
;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn d)
;;  (... (doodad-type d) (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d)))

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
(define TYPE-RADIAL-STAR "radial-star")
(define TYPE-SQUARE "square")
(define RADIAL-STAR-START-X 125)
(define RADIAL-STAR-START-Y 120)
(define SQUARE "square")
(define SQUARE-START-X 460)
(define SQUARE-START-Y 350)
(define RADIAL-STAR-VX 10)
(define RADIAL-STAR-VY 12)
(define SQUARE-VX -13)
(define SQUARE-VY -9)


(define RADIAL-STAR-START-COLOR "gold")
(define SQUARE-START-COLOR "gray")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; initial-world : Any -> World
;;; GIVEN: any value (ignored)
;;; RETURNS: the initial world specified for the animation
;;; EXAMPLE: (initial-world -174)
(define (initial-world v)
  (make-world
    (make-doodad TYPE-RADIAL-STAR RADIAL-STAR-START-X RADIAL-STAR-START-Y
                 RADIAL-STAR-VX RADIAL-STAR-VY RADIAL-STAR-START-COLOR
                 (radial-star 8 10 50 "outline" RADIAL-STAR-START-COLOR))
    (make-doodad TYPE-SQUARE SQUARE-START-X SQUARE-START-Y SQUARE-VX SQUARE-VY
                 SQUARE-START-COLOR (square 71 "outline" SQUARE-START-COLOR))
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
    (radial-star 8 10 50 "outline" (doodad-color star))
    (doodad-x star) (doodad-y star)
    scene))

;;  (make-doodad "radial-star" 10 10 5 5 (radial-star 8 10 50 "outline" color))
;;  (make-doodad "square" 10 10 5 5 (square 71 "outline" color))


;; place-square : Doodad Scene -> Scene
;; RETURNS: a scene like the given one, but with the given Doodad painted on it.
(define (place-square sq scene)
  (place-image
    (square 71 "outline" (doodad-color sq))
    (doodad-x sq) (doodad-y sq)
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
    (make-doodad
      (+ (doodad-x dood) RADIAL-STAR-VX)
      (+ (doodad-y dood) RADIAL-STAR-VY)
      (doodad-vx dood)
      (doodad-vy dood)
      (doodad-color dood)))
  

;; square-doodad-after-tick : Doodad -> Doodad
;; GIVEN: the state of a square-doodad dood
;; RETURNS: the state of the given doodad after a tick if it were in an unpaused world.

;; examples: 
;; 
;;
;; STRATEGY: use template for Doodad on dood

(define (square-doodad-after-tick dood)
    (make-doodad
      (+ (doodad-x dood) SQUARE-VX)
      (+ (doodad-y dood) SQUARE-VY)
      (doodad-vx dood)
      (doodad-vy dood)
      (doodad-color dood)))
  
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


;;; doodad-x : Doodad -> Integer
;;; doodad-y : Doodad -> Integer
;;; GIVEN: a Doodad
;;; RETURNS: the x or y coordinate of the Doodad
          
;;; doodad-vx : Doodad -> Integer
;;; doodad-vy : Doodad -> Integer
;;; GIVEN: a Doodad
;;; RETURNS: the vx or vy velocity component of the Doodad
          
;;; doodad-color : Doodad -> Color
;;; GIVEN: a Doodad
;;; RETURNS: the color of the Doodad, in one of the forms recognized
;;;     as a color by DrRacket's image-color? predicate

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS FOR TEST:
(define RADIAL-STAR-IMAGE (radial-star 8 10 50 "outline" "gold"))
(define SQUARE-IMAGE (square 71 "outline" "gray"))

(define world-scene-at-beginning
  (place-image RADIAL-STAR-IMAGE 125 120
               (place-image SQUARE-IMAGE 460 350 EMPTY-CANVAS)))

;; TESTS:
(begin-for-test

  (check-equal? world-scene-at-beginning (world-to-scene(initial-world 12)))

  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;