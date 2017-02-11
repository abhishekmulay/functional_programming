;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1-new) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "04" "q1-new.rkt")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            DATA DEFINITIONS                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Two moving draggable Doodads, they bounce off of the corner of rectangular
;; enclosure.
;; Animation can be paused using space key
;; Doodads can be dragged 
;; starts with (animation 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       DATA DEFINITIONS                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct
  world
  (doodads-star doodads-square paused? dotx doty
                previous-star-vx previous-star-vy
                previous-square-vx previous-square-vy))

(define-struct
  doodad (type x y vx vy color selected? x-offset y-offset age))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-world-with-paused w val)
  (make-world
   (world-doodads-star w)
   (world-doodads-square w)
   val
   (world-dotx w)
   (world-doty w)
   (world-previous-star-vx w)
   (world-previous-star-vy w)
   (world-previous-square-vx w)
   (world-previous-square-vy w)))


(define (make-world-with-doodads-star w val)
  (make-world
   val
   (world-doodads-square w)
   (world-paused? w)
   (world-dotx w)
   (world-doty w)
   (world-previous-star-vx w)
   (world-previous-star-vy w)
   (world-previous-square-vx w)
   (world-previous-square-vy w)))

(define (make-world-with-doodads-square w val)
  (make-world
   (world-doodads-star w)
   val
   (world-paused? w)
   (world-dotx w)
   (world-doty w)
   (world-previous-star-vx w)
   (world-previous-star-vy w)
   (world-previous-square-vx w)
   (world-previous-square-vy w)))




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

(define SQUARE-START-COLOR "gray")
(define GRAY "Gray")
(define OLIVE-DRAB "OliveDrab")
(define KHAKI "Khaki")
(define ORANGE "Orange")
(define CRIMSON "Crimson")

(define HALF-DOODAD-HEIGHT 71/2)
(define HALF-DOODAD-WIDTH  71/2)
(define X-MAX 661)
(define Y-MAX 449)

(define DEFAULT-SQUARE
         (make-doodad TYPE-SQUARE SQUARE-START-X SQUARE-START-Y SQUARE-VX SQUARE-VY
                      GRAY false 0 0 0))

(define DEFAULT-STAR
         (make-doodad TYPE-STAR STAR-START-X STAR-START-Y STAR-VX STAR-VY
                 GOLD false 0 0 0))

(define FIRST-ADDED-STAR
  (make-doodad TYPE-STAR 125 120 -1 -1 GOLD false 0 0 0))

(define FIRST-ADDED-SQUARE
  (make-doodad TYPE-SQUARE 460 350 -1 -1 GRAY false 0 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     Animation Launcher                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
  ;          (on-mouse world-after-mouse-event)
            ))

(define DEFAULT-WORLD
  (make-world
   (list DEFAULT-STAR DEFAULT-STAR)
   (list DEFAULT-SQUARE DEFAULT-SQUARE)
   false 0 0
   -12 10
   9 -13))

;; initial-world : Any -> World
;; GIVEN: any value (ignored)
;; RETURNS: the initial world specified for the animation
;; EXAMPLE: (initial-world -174) =
;; STRATEGY: Combine simpler functions
(define (initial-world v)
  DEFAULT-WORLD)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    Tick functions                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; world-after-tick : World -> World
;; GIVEN: any World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick
;; EXAMPLES: Available in comments
;; STRATEGY: Use template for world on w
(define (world-after-tick w)
  (if (world-paused? w)
    w
    (make-world
      (doodads-after-tick (world-doodads-star w))
      (doodads-after-tick (world-doodads-square w))
      (world-paused? w) 0 0 (world-previous-star-vx w) (world-previous-star-vy w)
      (world-previous-square-vx w) (world-previous-square-vy w))))

;(doodads-star doodads-square paused? dotx doty previous-star previous-square))

;; doodads-after-tick : Doodads -> Doodads
;; GIVEN: 
;; RETURNS: 
;; EXAMPLE:
;; STRATEGY:
(define (doodads-after-tick doods)
  (cond
    [(empty? doods) empty]
    [else (cons
           (doodad-after-tick (first doods))
           (doodads-after-tick (rest doods)))]))

;; doodad-after-tick : Doodad -> Doodad
;; GIVEN: 
;; RETURNS: 
;; EXAMPLE:
;; STRATEGY:
(define (doodad-after-tick dood)
  (cond
    [(doodad-selected? dood) dood]
    [else (new-doodad-after-tick dood)]))

(define (new-doodad-after-tick dood)
  (make-doodad
      (doodad-type dood)
      (next-x dood)
      (next-y dood)
      (next-vx dood)
      (next-vy dood)
      (check-color dood)
      (doodad-selected? dood)
      (doodad-x-offset dood)
      (doodad-y-offset dood)
      (+ 1 (doodad-age dood))))

(define (check-color dood)
  (cond
    [(core-bounce? dood) (next-color dood)]
    [else (doodad-color dood)]))
  
;; check-x: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of x for Doodad dood
;; EXAMPLE:
;; (check-x (make-doodad "radial-star" 490 -2 10 -12 "Green" #f 0 0)) = 510
;; (check-x (make-doodad "radial-star" 0 -2 -10 -12 "Green" #f 0 0)) = 10
;; STRATEGY: Use template for Doodad on dood
(define (next-x dood)
  (cond
     [(and (> (add-x-vx dood) 0) (< (add-x-vx dood) X-MAX))
      (add-x-vx dood)]
     [(<= (add-x-vx dood) 0) ( * -1 (add-x-vx dood))]
     [(>= (add-x-vx dood) X-MAX)
      (- (- X-MAX 1) (- (add-x-vx dood) (- X-MAX 1) ))]))

;; check-y: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of y for Doodad dood
;; EXAMPLE:
;; (check-y (make-doodad "radial-star" 490 2 10 12 "Green" #f 0 0)) = 14
;; (check-y (make-doodad "radial-star" 490 -2 10 -12 "Green" #f 0 0)) = 14
;; STRATEGY: Use template for Doodad on dood
(define (next-y dood)
  (cond
     [(and (> (add-y-vy dood) 0)(< (add-y-vy dood) Y-MAX))
      (add-y-vy dood)]
     [(<= (add-y-vy dood) 0) (* -1 (add-y-vy dood))]
     [(>= (add-y-vy dood) Y-MAX)
      (- (- Y-MAX 1) (- (add-y-vy dood) (- Y-MAX 1)))]))

;; check-vx: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of vx for Doodad dood
;; EXAMPLE:
;; (check-vx (make-doodad "radial-star" 490 2 10 12 "Green" #f 0 0)) = 500
;; (check-vx (make-doodad "radial-star" 0 2 -10 12 "Green" #f 0 0)) = 10
;; STRATEGY: Use template for Doodad on dood
(define (next-vx dood)
  (cond
     [(and (> (add-x-vx dood) 0) (< (add-x-vx dood) X-MAX)) (doodad-vx dood)]
     [(<= (add-x-vx dood) 0) ( * -1 (doodad-vx dood))]
     [(>= (add-x-vx dood) X-MAX) ( * -1 (doodad-vx dood))]))

;; check-vy: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of vy for Doodad dood
;; EXAMPLE:
;; (check-vy (make-doodad "radial-star" 490 2 10 12 "Green" #f 0 0)) = 14
;; (check-vy (make-doodad "radial-star" 0 -2 -10 -12 "Green" #f 0 0)) = 14
;; STRATEGY: Use template for Doodad on dood
(define (next-vy dood)
  (cond
     [(and (> (add-y-vy dood) 0) (< (add-y-vy dood) Y-MAX)) (doodad-vy dood)]
     [(<= (add-y-vy dood) 0) ( * -1 (doodad-vy dood))]
     [(>= (add-y-vy dood) Y-MAX) ( * -1 (doodad-vy dood))]))

;; core-bounce-x?: Doodad -> Boolean
;; GIVEN: a Doodad dood
;; RETURNS: if the Doodad should perform a core bounce because of change in x
;; EXAMPLE:
;; (core-bounce-x? (make-doodad "radial-star" 800 80 -10 12 "Green" #f 0 0))=\t
;; (core-bounce-x? (make-doodad "radial-star" 400 80 -10 12 "Green" #f 0 0))=\f
;; STRATEGY: Use template for Doodad on dood
(define (core-bounce-x? dood)
     (or (< (add-x-vx dood) 0) 
     (>= (add-x-vx dood) X-MAX)))

;; core-bounce-y?: Doodad -> Boolean
;; GIVEN: a Doodad dood
;; RETURNS: if the Doodad should perform a core bounce because of change in y
;; EXAMPLES:
;; (core-bounce-y? (make-doodad "radial-star" 400 80 -10 12 "Green" #f 0 0))=\f
;; (core-bounce-y? (make-doodad "radial-star" 400 -80 -10 12 "Green" #f 0 0))=\t
;; STRATEGY: Use template for Doodad on dood
(define (core-bounce-y? dood)
     (or (< (add-y-vy dood) 0) 
     (>= (+ (add-y-vy dood)) Y-MAX)))

;; core-bounce? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: true iff the given Doodad should do a core bounce because of change
;; in
;; EXAMPLE:
;; (core-bounce? (make-doodad "radial-star" 400 80 -10 12 "Green" #f 0 0))=\f
;; (core-bounce? (make-doodad "radial-star" 800 -80 -10 12 "Green" #f 0 0))=\t
;; STRATEGY: Combine simpler functions
(define (core-bounce? dood)
  (or (core-bounce-x? dood) (core-bounce-y? dood)))

(define (add-x-vx dood)
  (+ (doodad-x dood) (doodad-vx dood)))

(define (add-y-vy dood)
  (+ (doodad-y dood) (doodad-vy dood)))

;; next-color: String -> String 
;; GIVEN: Current color of Doodad as a string
;; RETURNS: Next color that should follow color c
;; EXAMPLE:
;;   (next-color "Green") = "Blue"
;;   (next-color "Blue") = "Gold"
;; STRATEGY: Break into cases based on c
(define (next-color dood)
  (next-color-for-color (doodad-color dood)))

(define (next-color-for-color c)
  (cond
    [(string=? c GOLD) GREEN]
    [(string=? c GREEN) BLUE]
    [(string=? c BLUE) GOLD]
    [(string=? c GRAY) OLIVE-DRAB]
    [(string=? c OLIVE-DRAB) KHAKI]
    [(string=? c KHAKI) ORANGE]
    [(string=? c ORANGE) CRIMSON]
    [(string=? c CRIMSON) GRAY]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Key event handlers                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (world-after-key-event w kev)
  (cond
    [(is-pause-key-event? kev) (world-with-paused-toggled w)]
    [(is-q-key-event? kev) (world-with-q-pressed w)]
    [(is-t-key-event? kev) (world-with-t-pressed w)]
    [else w]))

(define (is-pause-key-event? ke)
  (key=? ke " "))

(define (is-q-key-event? ke)
  (key=? ke "q"))

(define (is-t-key-event? ke)
  (key=? ke "t"))

(define (world-with-paused-toggled w)
  (make-world-with-paused w (not (world-paused? w))))

(define (world-with-q-pressed w)
  (make-world
   (world-doodads-star w)
   (add-new-square (world-doodads-square w) w)
   (world-paused? w)
   (world-dotx w)
   (world-doty w)
   (world-previous-star-vx w)
   (world-previous-star-vy w)
   (doodad-vx (new-square w))
   (doodad-vx (new-square w))))

(define (world-with-t-pressed w)
  (make-world
   (add-new-star (world-doodads-star w) w)
   (world-doodads-square w)
   (world-paused? w)
   (world-dotx w)
   (world-doty w)
   (doodad-vx (new-star w))
   (doodad-vy (new-star w))
   (world-previous-square-vx w)
   (world-previous-square-vy w)))

(define (add-new-square squares w)
  (cons (new-square w) squares))

(define (new-square w)
  (make-doodad TYPE-SQUARE 460 350  (* -1 (world-previous-square-vy w))
               (world-previous-square-vx w) GRAY false 0 0 0)) 

(define (add-new-star stars w)
  (cons (new-star w) stars))

(define (new-star w)
  (make-doodad TYPE-STAR 125 120 (* -1 (world-previous-star-vy w))
               (world-previous-star-vx w) GOLD false 0 0 0))

;(doodads-star doodads-square paused? dotx doty
;previous-star-vx previous-star-vy
;previous-square-vx previous-square-vy))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Drawing functions                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-to-scene : World -> Scene
;; GIVEN: a World
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: Available in tests
;; STRATEGY: Use template for World on w
(define (world-to-scene w)
  (place-stars
   (world-doodads-star w)
    (draw-squares w)
    (world-dotx w) (world-doty w)
   ))

(define (draw-squares w)
  (place-squares
   (world-doodads-square w) EMPTY-CANVAS (world-dotx w) (world-doty w)))

(define (place-stars stars scene dotx doty)
  (cond
    [(empty? stars) scene]
    [else (place-stars
           (rest stars)
           (place-star (first stars) scene dotx doty)
           dotx doty)]))

(define (place-star star scene dotx doty)
  (cond
    [(doodad-selected? star)
     (draw-doodad-with-dot star (draw-star-helper star scene) dotx doty)]
    [else (draw-star-helper star scene)]))

(define (place-squares squares scene dotx doty)
  (cond
    [(empty? squares) scene]
    [else (place-squares
           (rest squares)
           (place-square (first squares) scene dotx doty)
           dotx doty) ]))
  
(define (place-square sq scene dotx doty)
  (cond
    [(doodad-selected? sq)
     (draw-doodad-with-dot sq (draw-square-helper sq scene) dotx doty)]
    [else (draw-square-helper sq scene)])
  )

(define (draw-doodad-with-dot dood scene dotx doty)
  (place-image (circle 3 "solid" "black") dotx doty scene))

(define (draw-star-helper star scene)
  (place-image
    (radial-star 8 10 50 "solid" (doodad-color star))
    (doodad-x star) (doodad-y star)
    scene))

(define (draw-square-helper sq scene)
  (place-image
    (square 71 "solid" (doodad-color sq))
    (doodad-x sq) (doodad-y sq)
    scene))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(animation 1)
