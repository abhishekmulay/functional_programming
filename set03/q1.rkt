;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "03" "q1.rkt")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
 doodad-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Two moving Doodads, they bounce off of the corner of rectangular
;; enclosure.
;; Animation can be paused using space key
;; starts with (animation 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                         DATA DEFINITIONS                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-struct world (star square is-paused?))
;; A World is a (make-world Doodad Doodad Boolean)
;; star is Doodad shaped like a radial star
;; square is Doodad shaped like a square
;; is-paused? describes whether or not the world is paused

;; template:
;; world-fn : World -> ??
;; (define (world-fn w)
;;   (... (world-star w) (world-square w) (world-is-paused? w)))

(define-struct doodad (x y vx vy color))
;; A Doodad is:
;; -- (define-struct doodad (Int Int Int Int String))
;; INTERPRETATION:
;;   type: type is one of "radial-star" or "square"
;;   x: x-coordinate of Doodad
;;   y: x-coordinate of Doodad
;;   vx: number of pixels the Doodad moves on each tick in the x direction
;;   vy: number of pixels the Doodad moves on each tick in the y direction
;;   color: color of this Doodad as a String

;; EXAMPLE:
;;  (make-doodad "radial-star" 10 10 5 5 (radial-star 8 10 50 "outline" color))
;;  (make-doodad "square" 10 10 5 5 (square 71 "outline" color))
;;
;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn d)
;;  (... (doodad-type d) (doodad-x d) (doodad-y d) (doodad-vx d) (doodad-vy d)
;;       (doodad-color d)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           CONSTANTS                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define CANVAS-WIDTH 601)
(define CANVAS-HEIGHT 449)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
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

(define SQUARE-START-COLOR "gray")
(define STAR-START-COLOR "Gold")
(define GOLD "Gold")
(define GREEN "Green")
(define BLUE "Blue")
(define GRAY "Gray")
(define OLIVE-DRAB "OliveDrab")
(define KHAKI "Khaki")
(define ORANGE "Orange")
(define CRIMSON "Crimson")

(define X-MAX 601)
(define Y-MAX 449)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           Animation and World methods                      ;;
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
;; STRATEGY: Combine simpler functions
(define (animation speed)
  (big-bang (initial-world speed)
            (on-tick world-after-tick speed)
            (on-draw world-to-scene)
            (on-key world-after-key-event)))

;; initial-world : Any -> World
;; GIVEN: any value (ignored)
;; RETURNS: the initial world specified for the animation
;; EXAMPLE: (initial-world -174)
;; STRATEGY: Combine simpler functions
(define (initial-world v)
  (make-world
    (make-doodad STAR-START-X STAR-START-Y STAR-VX STAR-VY
                 GOLD)
    (make-doodad SQUARE-START-X SQUARE-START-Y SQUARE-VX SQUARE-VY
                 GRAY)
    false))

;; world-paused? : World -> Boolean
;; GIVEN: a World
;; RETURNS: true iff the World is paused
;; EXAMPLES: (world-paused? w) = true
;;           (world-paused? w) = false
;; STRATEGY: Use template for World on w
(define (world-paused? w)
  (world-is-paused? w))

;; world-doodad-star : World -> Doodad
;; GIVEN: a World
;; RETURNS: the star-like Doodad of the World
;; EXAMPLE: (world-doodad-star w) = 
;; STRATEGY: Use template for World on w
(define (world-doodad-star w)
  (world-star w))

;; world-doodad-square : World -> Doodad
;; GIVEN: a World
;; RETURNS: the square Doodad of the World
;; STRATEGY: Use template for World on w
(define (world-doodad-square w)
  (world-square w))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           Drawing methods                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; GIVEN: Star-like Doodad of the world and Scene on which the Doodad is to be
;;        drawn
;; EXAMPLES: Check in test cases
;; RETURNS: a scene like the given one, but with the given Doodad painted
;;          on it.
;; STRATEGY: Use template for Doodad on star
(define (place-star star scene)
  (place-image
    (radial-star 8 10 50 "solid" (doodad-color star))
    (doodad-x star) (doodad-y star)
    scene))

;; place-square : Doodad Scene -> Scene
;; GIVEN: Square Doodad of the world and Scene on which the Doodad is to be
;;        drawn
;; RETURNS: a scene like the given one, but with the given Doodad painted on it.
;; EXAMPLE: 
;; STRATEGY: Use template for Doodad on sq
(define (place-square sq scene)
  (place-image
    (square 71 "solid" (doodad-color sq))
    (doodad-x sq) (doodad-y sq)
    scene))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           After tick handler                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; doodad-after-tick : Doodad -> Doodad
;; GIVEN: the state of a star-like Doodad
;; RETURNS: the state of the given Doodad after a tick if it were in an
;;          unpaused world.
;; EXAMPLES: 
;;
;; STRATEGY: use template for Doodad on dood
(define (doodad-after-tick dood)
  (make-doodad
   (check-x dood)
   (check-y dood)
   (check-vx dood)
   (check-vy dood)
   (check-color dood)))

;; check-x: Doodad -> Integer
;; GIVEN: A Doodad dood
;; RETURNS: The new value of x co-ordinate of this Doodad subject to conditions
;; EXAMPLES:
;; STRATEGY: use template for Doodad on dood
(define (check-x dood)
  (cond
     [(and (> (+ (doodad-x dood) (doodad-vx dood)) 0)
           (< (+ (doodad-x dood) (doodad-vx dood)) X-MAX))
      (+ (doodad-x dood) (doodad-vx dood))]
     [(<= (+ (doodad-x dood) (doodad-vx dood)) 0)
      ( * -1 (+ (doodad-x dood) (doodad-vx dood)))]
     [(>= (+ (doodad-x dood) (doodad-vx dood)) X-MAX)
      (- (- X-MAX 1) (- (+ (doodad-x dood) (doodad-vx dood)) (- X-MAX 1)))]))

;; check-y: Doodad -> Integer
;; GIVEN: A Doodad dood
;; RETURNS: The new value of y co-ordinate of this Doodad subject to conditions
;; EXAMPLES:
;; STRATEGY: use template for Doodad on dood
(define (check-y dood)
  (cond
     [(and (> (+ (doodad-y dood) (doodad-vy dood)) 0)
           (< (+ (doodad-y dood) (doodad-vy dood)) Y-MAX))
      (+ (doodad-y dood) (doodad-vy dood))]
     [(<= (+ (doodad-y dood) (doodad-vy dood)) 0)
      (* -1 (+ (doodad-y dood) (doodad-vy dood)))]
     [(>= (+ (doodad-y dood) (doodad-vy dood)) Y-MAX)
      (- (- Y-MAX 1) (- (+ (doodad-y dood) (doodad-vy dood)) (- Y-MAX 1)))]))

;; check-vx: Doodad -> Integer
;; GIVEN: A Doodad dood
;; RETURNS: The new value of x velocity of this Doodad subject to conditions
;; EXAMPLES:
;; STRATEGY: use template for Doodad on dood
(define (check-vx dood)
  (cond
     [(and (> (+ (doodad-x dood) (doodad-vx dood)) 0)
           (< (+ (doodad-x dood) (doodad-vx dood)) X-MAX))
      (doodad-vx dood)]
     [(<= (+ (doodad-x dood) (doodad-vx dood)) 0)
      ( * -1 (doodad-vx dood))]
     [(>= (+ (doodad-x dood) (doodad-vx dood)) X-MAX)
      ( * -1 (doodad-vx dood))]))

;; check-vy: Doodad -> Integer
;; GIVEN: A Doodad dood
;; RETURNS: The new value of y velocity of this Doodad subject to conditions 
;; EXAMPLES:
;; STRATEGY: use template for Doodad on dood
(define (check-vy dood)
  (cond
     [(and (> (+ (doodad-y dood) (doodad-vy dood)) 0)
           (< (+ (doodad-y dood) (doodad-vy dood)) Y-MAX))
      (doodad-vy dood)]
     [(<= (+ (doodad-y dood) (doodad-vy dood)) 0)
      ( * -1 (doodad-vy dood))]
     [(>= (+ (doodad-y dood) (doodad-vy dood)) Y-MAX)
      ( * -1 (doodad-vy dood))]))

;; core-bounce-x?: Doodad -> Boolean
;; GIVEN: a Doodad dood
;; RETURNS: Returns true if the Doodad can perform a core bounce because of
;;          change in x property
;; EXAMPLE: (core-bounce-x? dood) = true
;;          (core-bounce-x? dood) = false
;; STRATEGY: use template for Doodad on dood
(define (core-bounce-x? dood)
     (or (< (+ (doodad-x dood) (doodad-vx dood)) 0) 
     (>= (+ (doodad-x dood) (doodad-vx dood)) X-MAX)))

;; core-bounce-y?: Doodad -> Boolean
;; GIVEN: a Doodad dood
;; RETURNS: Returns true if the Doodad can perform a core bounce because of
;;          change in y property
;; EXAMPLE: (core-bounce-y? dood) = true
;;          (core-bounce-y? dood) = false
;; STRATEGY: use template for Doodad on dood
(define (core-bounce-y? dood)
     (or (< (+ (doodad-y dood) (doodad-vy dood)) 0) 
     (>= (+ (doodad-y dood) (doodad-vy dood)) Y-MAX)))

;; core-bounce? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true iff the given Doodad should perform a core bounce
;; EXAMPLE: (core-bounce? dood) = true
;;          (core-bounce? dood) = false
;; STRATEGY: Combine simpler functions
(define (core-bounce? dood)
  (or (core-bounce-x? dood) (core-bounce-y? dood)))

;; check-color: Doodad -> String 
;; GIVEN: Current color of Doodad
;; RETURNS:Next color that should follow current color. If there has been a
;;         core bounce, get next color for that Doodad else keep the same
;;         color of that Doodad
;; EXAMPLES:
;; STRATEGY:Use template for Doodad on dood
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           Key event handlers                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; GIVEN: a World w
;; RETURNS: a world just like the given one, but with paused? toggled
;; EXAMPLES:
;; STRATEGY: use template for World on w
(define (world-with-paused-toggled w)
  (make-world
   (world-star w)
   (world-square w)
   (not (world-paused? w))))

;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
;; EXAMPLE: (is-pause-key-event? " ") = true
;; STRATEGY: Combine simpler functions
(define (is-pause-key-event? ke)
  (key=? ke " "))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS FOR TEST:
(define RADIAL-STAR-IMAGE (radial-star 8 10 50 "solid" "gold"))
(define SQUARE-IMAGE (square 71 "solid" "gray"))

(define world-scene-at-beginning
  (place-image RADIAL-STAR-IMAGE 125 120
               (place-image SQUARE-IMAGE 460 350 EMPTY-CANVAS)))

(define STAR-OUTSIDE-X-LIMIT (make-doodad 700 80 -10 12 "Green"))
(define STAR-OUTSIDE-Y-LIMIT (make-doodad 553 500 -13 -9 "Khaki"))
(define STAR-IN-LIMIT (make-doodad 553 80 -10 12 "Green"))
(define SQUARE-OUTSIDE-X-LIMIT (make-doodad 666 380 -13 -9 "Khaki"))
(define SQUARE-OUTSIDE-Y-LIMIT (make-doodad 553 -10 -13 0 "Khaki"))
(define SQUARE-IN-LIMIT (make-doodad 658 380 -13 -9 "Khaki"))


(define STAR-ABOUT-TO-BOUNCE-X-MAX (make-doodad 601 400 -10 12 "Green"))
(define STAR-AFTER-BOUNCE-X-MAX (make-doodad 591 412 -10 12 "Green"))

(define STAR-ABOUT-TO-BOUNCE-X-MIN (make-doodad -1 400 -10 12 "Green"))
(define STAR-AFTER-BOUNCE-X-MIN (make-doodad 11 412 10 12 "Blue"))

(define STAR-ABOUT-TO-BOUNCE-Y-MAX (make-doodad 600 489 -10 12 "Green"))
(define STAR-AFTER-BOUNCE-Y-MAX (make-doodad 590 395 -10 -12 "Blue"))

(define STAR-ABOUT-TO-BOUNCE-Y-MIN (make-doodad 600 -1 -10 12 "Green"))
(define STAR-AFTER-BOUNCE-Y-MIN (make-doodad 590 11 -10 12 "Green"))

(define SQUARE-ABOUT-TO-BOUNCE-X-MAX (make-doodad 601 400 12 12 "Green"))
(define SQUARE-AFTER-BOUNCE-X-MAX (make-doodad 512 396 12 -12 "Blue"))

(define SQUARE-ABOUT-TO-BOUNCE-Y-MAX (make-doodad 500 489 12 12 "Green"))
(define SQUARE-AFTER-BOUNCE-Y-MAX (make-doodad 512 395 12 -12 "Blue"))


(define UNPAUSED-WORLD (make-world
                                    STAR-ABOUT-TO-BOUNCE-X-MAX
                                    STAR-ABOUT-TO-BOUNCE-Y-MAX false))
(define PAUSED-WORLD (make-world
                                    STAR-ABOUT-TO-BOUNCE-X-MAX
                                    STAR-ABOUT-TO-BOUNCE-Y-MAX true))

(define UNPAUSED-WORLD-BEFORE-TICK (make-world
                                    STAR-ABOUT-TO-BOUNCE-X-MAX
                                    STAR-ABOUT-TO-BOUNCE-Y-MAX false))
(define UNPAUSED-WORLD-AFTER-TICK (make-world
                                     STAR-AFTER-BOUNCE-X-MAX
                                     STAR-AFTER-BOUNCE-Y-MAX false))

(define UNPAUSED-WORLD-MIN-BEFORE-TICK (make-world
                                    STAR-ABOUT-TO-BOUNCE-X-MIN
                                    STAR-ABOUT-TO-BOUNCE-Y-MIN false))
(define UNPAUSED-WORLD-MIN-AFTER-TICK (make-world
                                     STAR-AFTER-BOUNCE-X-MIN
                                     STAR-AFTER-BOUNCE-Y-MIN false))

(define PAUSED-WORLD-BEFORE-TICK (make-world
                                      SQUARE-ABOUT-TO-BOUNCE-X-MAX
                                      SQUARE-ABOUT-TO-BOUNCE-Y-MAX true))
(define PAUSED-WORLD-AFTER-TICK (make-world
                                     SQUARE-ABOUT-TO-BOUNCE-X-MAX
                                     SQUARE-ABOUT-TO-BOUNCE-Y-MAX true))
;; TESTS:
(begin-for-test

  ;; tests for world
  (check-equal? world-scene-at-beginning (world-to-scene(initial-world 12)))
  
  (check-equal? (world-after-tick UNPAUSED-WORLD-BEFORE-TICK)
                UNPAUSED-WORLD-AFTER-TICK
                "Unpaused World after tick should match world with expected")
  
  (check-equal? (world-after-tick UNPAUSED-WORLD-MIN-BEFORE-TICK)
                UNPAUSED-WORLD-MIN-AFTER-TICK
                "Unpaused World after tick should match world with expected")

  (check-equal? (world-doodad-star UNPAUSED-WORLD)
                STAR-ABOUT-TO-BOUNCE-X-MAX
                "Should return star-like Doodad of the world")

  (check-equal? (world-doodad-square UNPAUSED-WORLD)
                STAR-ABOUT-TO-BOUNCE-Y-MAX
                "Should return star-like Doodad of the world")
  
  (check-equal? (world-after-tick PAUSED-WORLD-BEFORE-TICK)
                PAUSED-WORLD-AFTER-TICK
                "Paused World after tick should not change when paused")

  (check-equal? (world-after-key-event UNPAUSED-WORLD " " ) PAUSED-WORLD
                "Paused World should pause on ' ' key event ")
  
  (check-equal? (world-after-key-event UNPAUSED-WORLD "\t" ) UNPAUSED-WORLD
                "Paused World should not change on \t key event ")
  
  (check-equal? (check-y SQUARE-OUTSIDE-Y-LIMIT) 10 "y Should be 10")
  (check-equal? (check-vy SQUARE-OUTSIDE-Y-LIMIT) 0 "y Should be 0")
  
  ;; tests for core bounce
  (check-equal? (core-bounce? STAR-OUTSIDE-X-LIMIT) true
                "Should perform a core bounce" )
  (check-equal? (core-bounce? STAR-OUTSIDE-Y-LIMIT) true
                "Should perform a core bounce" )
  (check-equal? (core-bounce? SQUARE-OUTSIDE-X-LIMIT) true
                "Should perform a core bounce" )
  (check-equal? (core-bounce? SQUARE-OUTSIDE-Y-LIMIT) true
                "Should perform a core bounce" )
  
  (check-equal? (doodad-after-tick STAR-ABOUT-TO-BOUNCE-X-MAX)
                STAR-AFTER-BOUNCE-X-MAX
                "This Doodad should bounce")
  (check-equal? (doodad-after-tick SQUARE-OUTSIDE-X-LIMIT)
                (make-doodad 547 371 13 -9 "Orange")
                "This Doodad should bounce")
  
  ;; tests for next-color
  (check-equal? (next-color GOLD) GREEN)
  (check-equal? (next-color GREEN) BLUE)
  (check-equal? (next-color BLUE) GOLD)
  (check-equal? (next-color GRAY) OLIVE-DRAB)
  (check-equal? (next-color OLIVE-DRAB) KHAKI)
  (check-equal? (next-color KHAKI) ORANGE)
  (check-equal? (next-color ORANGE) CRIMSON)
  (check-equal? (next-color CRIMSON) GRAY)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;