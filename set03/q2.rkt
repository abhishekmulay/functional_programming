;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "03" "q2.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide
 animation
 initial-world
 world-after-tick
 world-after-key-event
 world-paused?
 world-doodad-star
 world-doodad-square
 doodad-x
 doodad-y
 doodad-vx
 doodad-vy
 doodad-color
 world-after-mouse-event
 doodad-after-mouse-event
 doodad-selected?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; There are two doodads. They are moving and changing color as result of
;; change in position.
;; Pressing space pauses or unpauses the entire system.

;; starts with (animation 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

(define-struct world (star square is-paused?))
;; A World is a (make-world Doodad Doodad Boolean)
;; star is Doodad shaped like a radial star
;; square is Doodad shaped like a square
;; is-paused? describes whether or not the world is paused

;; template:
;; world-fn : World -> ??
;; (define (world-fn w)
;;   (... (world-star w) (world-square w) (world-is-paused? w)))

(define-struct doodad (type x y vx vy color selected?))
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
;;  (... (doodad-type d) (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d) (doodad-color d)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS:
(define CANVAS-WIDTH 601)
(define CANVAS-HEIGHT 449)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define TYPE-STAR "radial-star")
(define TYPE-SQUARE "square")
(define STAR-START-X 125)
(define STAR-START-Y 120)
(define STAR-VX 10)
(define STAR-VY 12)
(define SQUARE "square")
(define SQUARE-START-X 460)
(define SQUARE-START-Y 350)
(define SQUARE-VX -13)
(define SQUARE-VY -9)

(define STAR-POINT 8)
(define STAR-INNER-RADIUS 10)
(define STAR-OUTTER-RADIUS 50)
(define SQUARE-SIDE 71)

(define STAR-START-COLOR "Gold")
(define GOLD "Gold")
(define GREEN "Green")
(define BLUE "Blue")

(define GRAY "Gray")
(define OLIVE-DRAB "OliveDrab")
(define KHAKI "Khaki")
(define ORANGE "Orange")
(define CRIMSON "Crimson")

(define SQUARE-START-COLOR "gray")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; animation : PosReal -> World
;; GIVEN: the speed of the animation, in seconds per tick
;;        (so larger numbers run slower)
;; EFFECT: runs the animation, starting with the initial world as
;;         specified in the problem set
;; RETURNS: the final state of the world
;; EXAMPLES:
;;         (animation 1) runs the animation at normal speed
;;         (animation 1/4) runs at a faster than normal speed
(define (animation speed)
  (big-bang (initial-world speed)
            (on-tick world-after-tick speed)
            (on-draw world-to-scene)
            (on-key world-after-key-event)
            (on-mouse world-after-mouse-event)))

;; world-after-mouse-event : World Integer Integer MouseEvent -> World
;; GIVEN: a world and a description of a mouse event
;; RETURNS: the world that should follow the given mouse event
;; STRATEGY: use template for World on w
(define (world-after-mouse-event w mx my mev)
  (make-world
    (doodad-after-mouse-event (world-star w) mx my mev)
    (doodad-after-mouse-event (world-square w) mx my mev)
    (world-paused? w)))

;;; initial-world : Any -> World
;;; GIVEN: any value (ignored)
;;; RETURNS: the initial world specified for the animation
;;; EXAMPLE: (initial-world -174)
(define (initial-world v)
  (make-world
    (make-doodad TYPE-STAR STAR-START-X STAR-START-Y STAR-VX STAR-VY
                 GOLD false)
    (make-doodad TYPE-SQUARE SQUARE-START-X SQUARE-START-Y SQUARE-VX SQUARE-VY
                 GRAY false)
    false))

;; world-to-scene : World -> Scene
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: (world-to-scene paused-world-at-20) should return a canvas with
;;          two Doodads, one at (125, 120) and one at (460, 350)
;; STRATEGY: Use template for World on w
(define (world-to-scene w)
  (place-star
    (world-star w)
    (place-square
      (world-square w)
      EMPTY-CANVAS)))

;; place-radial-star : Doodad Scene -> Scene
;; RETURNS: a scene like the given one, but with the given Doodad painted
;; on it.
(define (place-star star scene)
  (place-image
    (radial-star 8 10 50 "solid" (doodad-color star))
    (doodad-x star) (doodad-y star)
    scene))

;; place-square : Doodad Scene -> Scene
;; RETURNS: a scene like the given one, but with the given Doodad painted on it.
(define (place-square sq scene)
  (place-image
    (square 71 "solid" (doodad-color sq))
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
      (doodad-after-tick (world-star w))
      (doodad-after-tick (world-square w))
      (world-paused? w))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doodad-after-mouse-event : Doodad -> Doodad
(define (doodad-after-mouse-event dood mx my mev)
  (cond
    [(mouse=? mev "button-down") (doodad-after-button-down dood mx my)]
    [(mouse=? mev "drag") (doodad-after-drag dood mx my)]
    [(mouse=? mev "button-up") (doodad-after-button-up dood mx my)]
    [else dood]))

;; helper functions:

;; cat-after-button-down : Cat Integer Integer -> Cat
;; RETURNS: the cat following a button-down at the given location.
;; STRATEGY: Use template for Cat on c
(define (doodad-after-button-down dood x y)
  (if (in-doodad? dood x y)
      (make-doodad (doodad-type dood) x y (doodad-vx dood) (doodad-vy dood) (doodad-color dood) true)
      dood))

;(make-doodad TYPE-STAR STAR-START-X STAR-START-Y STAR-VX STAR-VY GOLD)

(define HALF-DOODAD-HEIGHT 71/2)
(define HALF-DOODAD-WIDTH  71/2)

;; cat-after-drag : Cat Integer Integer -> Cat
;; RETURNS: the cat following a drag at the given location
;; STRATEGY: Use template for Cat on c
(define (doodad-after-drag dood x y)
  (if (doodad-selected? dood)
      (make-doodad (doodad-type dood) x y (doodad-vx dood) (doodad-vy dood) (doodad-color dood) true)
      dood))

;; cat-after-button-up : Cat Integer Integer -> Cat
;; RETURNS: the cat following a button-up at the given location
;; STRATEGY: Use template for Cat on c
(define (doodad-after-button-up dood x y)
  (if (doodad-selected? dood)
      (make-doodad (doodad-type dood) x y (doodad-vx dood) (doodad-vy dood) (doodad-color dood) false)
      dood))

;; in-cat? : Cat Integer Integer -> Cat
;; RETURNS true iff the given coordinate is inside the bounding box of
;; the given cat.
;; EXAMPLES: see tests below
;; STRATEGY: Use template for Cat on c
(define (in-doodad? dood x y)
  (and
    (<= 
      (- (doodad-x dood) HALF-DOODAD-WIDTH)
      x
      (+ (doodad-x dood) HALF-DOODAD-WIDTH))
    (<= 
      (- (doodad-y dood) HALF-DOODAD-HEIGHT)
      y
      (+ (doodad-y dood) HALF-DOODAD-HEIGHT))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; doodad-after-tick : Doodad -> Doodad
;; GIVEN: the state of a radial-star-doodad dood
;; RETURNS: the state of the given doodad after a tick if it were in an unpaused world.

;; examples: 
;; 
;;
;; STRATEGY: use template for Doodad on dood
(define (doodad-after-tick dood)
  (make-doodad
   TYPE-STAR
   (check-x dood)
   (check-y dood)
   (check-vx dood)
   (check-vy dood)
   (check-color dood)
   (doodad-selected? dood)))

;; check-x: Doodad -> Integer
;; GIVEN: 
;; RETURNS: 
;; STRATEGY: 
(define (check-x dood)
  (cond
     [(and (> (+ (doodad-x dood) (doodad-vx dood)) 0)
           (< (+ (doodad-x dood) (doodad-vx dood)) 601))
      (+ (doodad-x dood) (doodad-vx dood))]
     [(<= (+ (doodad-x dood) (doodad-vx dood)) 0)
      ( * -1 (+ (doodad-x dood) (doodad-vx dood)))]
     [(>= (+ (doodad-x dood) (doodad-vx dood)) 601)
      (- 600 (- (+ (doodad-x dood) (doodad-vx dood)) 600))]))


;; check-y: Doodad -> Integer
;; GIVEN: 
;; RETURNS: 
;; STRATEGY: 
(define (check-y dood)
  (cond
     [(and (> (+ (doodad-y dood) (doodad-vy dood)) 0)
           (< (+ (doodad-y dood) (doodad-vy dood)) 449))
      (+ (doodad-y dood) (doodad-vy dood))]
     [(<= (+ (doodad-y dood) (doodad-vy dood)) 0)
      (* -1 (+ (doodad-y dood) (doodad-vy dood)))]
     [(>= (+ (doodad-y dood) (doodad-vy dood)) 449)
      (- 448 (- (+ (doodad-y dood) (doodad-vy dood)) 448))]))

;; check-vx: Doodad -> Integer
;; GIVEN: 
;; RETURNS: 
;; STRATEGY: 
(define (check-vx dood)
  (cond
     [(and (> (+ (doodad-x dood) (doodad-vx dood)) 0)
           (< (+ (doodad-x dood) (doodad-vx dood)) 601))
      (doodad-vx dood)]
     [(<= (+ (doodad-x dood) (doodad-vx dood)) 0)
      ( * -1 (doodad-vx dood))]
     [(>= (+ (doodad-x dood) (doodad-vx dood)) 601)
      ( * -1 (doodad-vx dood))]))

;; check-vy: Doodad -> Integer
;; GIVEN: 
;; RETURNS: 
;; STRATEGY: 
(define (check-vy dood)
  (cond
     [(and (> (+ (doodad-y dood) (doodad-vy dood)) 0)
           (< (+ (doodad-y dood) (doodad-vy dood)) 449))
      (doodad-vy dood)]
     [(<= (+ (doodad-y dood) (doodad-vy dood)) 0)
      ( * -1 (doodad-vy dood))]
     [(>= (+ (doodad-y dood) (doodad-vy dood)) 449)
      ( * -1 (doodad-vy dood))]))

;; core-bounce-x?: Doodad -> Boolean
;; GIVEN: 
;; RETURNS: 
;; STRATEGY: 
(define (core-bounce-x? dood)
     (or (< (+ (doodad-x dood) (doodad-vx dood)) 0) 
     (>= (+ (doodad-x dood) (doodad-vx dood)) 601)))

;; core-bounce-y?: Doodad -> Boolean
;; GIVEN: 
;; RETURNS: 
;; STRATEGY: Use template for Doodad on dood
(define (core-bounce-y? dood)
     (or (< (+ (doodad-y dood) (doodad-vy dood)) 0) 
     (>= (+ (doodad-y dood) (doodad-vy dood)) 449)))

;; core-bounce? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true iff the given Doodad should do a core bounce because of change
;; in
;; STRATEGY: 
(define (core-bounce? dood)
  (or (core-bounce-x? dood) (core-bounce-y? dood)))

;; check-color: Doodad -> String 
;; GIVEN: Current color of Doodad
;; RETURNS: Next color that should follow current color
;; STRATEGY: Use template for Doodad on dood
(define (check-color dood)
  (cond
    [(core-bounce? dood) (next-color (doodad-color dood))]
    [else (doodad-color dood)]))

;; next-color: String -> String 
;; GIVEN: Current color as a string
;; RETURNS: Next color that should follow color c
;; STRATEGY: Break into cases based on c
(define (next-color c)
  (cond
    [(string=? c GOLD) GREEN]
    [(string=? c GREEN) BLUE]
    [(string=? c BLUE) GOLD]
    [(string=? c GRAY) OLIVE-DRAB]
    [(string=? c OLIVE-DRAB) KHAKI]
    [(string=? c KHAKI) ORANGE]
    [(string=? c ORANGE) CRIMSON]
    [(string=? c CRIMSON) GRAY]))

;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow the given world after the given key
;; event. on space, toggle paused?-- ignore all others
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
   (world-star w)
   (world-square w)
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
  (world-star w))

;; world-doodad-square : World -> Doodad
;; GIVEN: a World
;; RETURNS: the square Doodad of the World
(define (world-doodad-square w)
  (world-square w))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            Question 2                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-mouse-event: World Int Int MouseEvent -> World
;; GIVEN: A world, the x- and y-coordinates of a mouse event, and the
;;     mouse event
;; RETURNS: the world that should follow the given world after the
;;     given mouse event
          
;; doodad-after-mouse-event :  Doodad Int Int MouseEvent -> Doodad
;; GIVEN: A doodad, the x- and y-coordinates of a mouse event, and
;;     the mouse event
;; RETURNS: the doodad as it should be after the given mouse event
          
;; doodad-selected? : Doodad -> Boolean
;; RETURNS: true iff the given doodad is selected


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS FOR TEST:
(define RADIAL-STAR-IMAGE (radial-star 8 10 50 "solid" "gold"))
(define SQUARE-IMAGE (square 71 "solid" "gray"))

(define world-scene-at-beginning
  (place-image RADIAL-STAR-IMAGE 125 120
               (place-image SQUARE-IMAGE 460 350 EMPTY-CANVAS)))
 
;; TESTS:
(begin-for-test

  (check-equal? world-scene-at-beginning (world-to-scene(initial-world 12)))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(animation 1/2)