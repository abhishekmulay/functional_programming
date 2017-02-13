;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "04" "q1.rkt")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                           SYSTEM GOAL                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Two moving draggable Doodads, they bounce off of the corner of rectangular
;; enclosure.
;; Animation can be paused using space key
;; Doodads can be added by pressing "q" or "t" key and they can be removed by
;; pressing "." key
;; starts with (animation 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       DATA DEFINITIONS                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct world (doodads-star doodads-square paused? dotx doty
                                   previous-star-vx previous-star-vy
                                   previous-square-vx previous-square-vy))

;; A World is a (make-world ListOfDoodad ListOfDoodad Boolean
;;                          Integer Integer Integer Integer Integer Integer)
;;
;; doodads-star: is ListOfDoodad where each Doodad is shaped like a radial star
;; doodads-square: is a ListOfDoodad where each Doodad shaped like a square
;; is-paused?: describes whether or not the world is paused
;; dotx: x co-ordinate for center of black dot
;; doty: y co-ordinate for center of black dot
;; previous-star-vx: 
;; previous-star-vy: 
;; previous-square-vx: 
;; previous-square-vy: 

;; TEMPLATE:
;; world-fn : World -> ??
;;(define (world-fn w)
;;  (... (world-star w) (world-square w) (world-is-paused? w) (world-dotx w)
;;       (world-doty w)(previous-star-vx w) previous-star-vy w)
;;       (previous-square-vx w) (previous-square-vy w))


(define-struct doodad (type x y vx vy color selected? x-offset y-offset age))

;; A Doodad is:
;; -- (make-doodad (String Integer Integer Integer Integener String
;;      Boolean Integer Integer))
;; INTERPRETATION:
;;   type: denotes type of Doodad as a String
;;   type is one of:
;;      -- "radial-star"
;;      -- "square"
;;   x: x-coordinate of Doodad
;;   y: x-coordinate of Doodad
;;   vx: number of pixels the Doodad moves on each tick in the x direction
;;   vy: number of pixels the Doodad moves on each tick in the y direction
;;   color: color of this Doodad as a String identified by Dr.Racket IDE
;;   color is one of:
;;     For star-like Doodad
;;       -- "Gold"   
;;       -- "Green"
;;       -- "Blue"
;;
;;     For square Doodad
;;       -- "gray"
;;       -- "Gray"
;;       -- "OliveDrab"
;;       -- "Khaki"
;;       -- "Orange"
;;       -- "Crimson"
;;
;;   selected?: describes whether or not the Doodad is selected.
;;   x-offset: Difference of x co-cordinate of previously clicked mouse position
;;             from center of Doodad
;;   y-offset: Difference of y co-cordinate of previously clicked mouse position
;;             from center of Doodad
;;   age: 

;; EXAMPLE:
;;  (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0 5) =
;;  (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0 5)
;;
;;  (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0 2) =
;;  (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0 2)
;;
;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn dood)
;;  (... (doodad-type dood) (doodad-x dood) (doodad-y dood) (doodad-vx dood)
;;       (doodad-vy dood) (doodad-color dood) (doodad-selected? dood)
;;       (doodad-xd dood) (doodad-yd dood) (doodad-age dood)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(define HALF-SQUARE-HEIGHT 71/2)
(define HALF-SQUARE-WIDTH  71/2)
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

;; make-world-with-paused: World Boolean -> World
;; GIVEN: a World
;; RETURNS: a World just like the given one, but with paused? toggled
;; EXAMPLE:
;; STRATEGY: use template for World on w
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

;; make-world-with-doodads-star: World ListOfDoodad -> World
;; GIVEN: a World and a ListOfDoodad
;; RETURNS: a World with given ListOfDoodad for star like Doodads
;; EXAMPLE:
;; STRATEGY: Use template for World on w 
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

;; make-world-with-doodads-square: World ListOfDoodads -> World
;; GIVEN: a ListOfDoodad and ListOfDoodad with square Doodads
;; RETURNS: a World with new ListOfDoodads with square Doodad
;; EXAMPLE:
;; STRATEGY: Use template for World on w
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
            (on-mouse world-after-mouse-event)))

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

;; doodads-after-tick : ListOfDooodads -> ListOfDooodads
;; GIVEN: a ListOfDoodads
;; RETURNS: a ListOfDooodads after a tick in the world
;; EXAMPLE:
;; STRATEGY: Use template for ListOfDoodad on doods
(define (doodads-after-tick doods)
  (cond
    [(empty? doods) empty]
    [else (cons
           (doodad-after-tick (first doods))
           (doodads-after-tick (rest doods)))]))

;; doodad-after-tick : Doodad -> Doodad
;; GIVEN: a Doodad 
;; RETURNS: a Doodad that should follow given Doodad after a tick
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on dood
(define (doodad-after-tick dood)
  (cond
    [(doodad-selected? dood) dood]
    [else (new-doodad-after-tick dood)]))

;; new-doodad-after-tick: Doodad -> Doodad
;; GIVEN: a Doodad
;; RETURNS: a new Doodad that should follow the given Doodad after a tick
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on dood
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

;; check-color: Doodad -> String
;; GIVEN: a Doodad 
;; RETURNS: color of Doodad as String if Doodad has preformed a core bounce
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on dood
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
     [(x-in-range? dood) (add-x-vx dood)]
     [(x-below-range? dood) ( * -1 (add-x-vx dood))]
     [(x-above-range? dood) (- (- X-MAX 1) (- (add-x-vx dood) (- X-MAX 1) ))]))

;; check-y: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of y for Doodad dood
;; EXAMPLE:
;; (check-y (make-doodad "radial-star" 490 2 10 12 "Green" #f 0 0)) = 14
;; (check-y (make-doodad "radial-star" 490 -2 10 -12 "Green" #f 0 0)) = 14
;; STRATEGY: Use template for Doodad on dood
(define (next-y dood)
  (cond
    [(y-in-range? dood) (add-y-vy dood)]
    [(y-below-range? dood) (* -1 (add-y-vy dood))]
    [(y-above-range? dood) (- (- Y-MAX 1) (- (add-y-vy dood) (- Y-MAX 1)))]))

;; check-vx: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of vx for Doodad dood
;; EXAMPLE:
;; (check-vx (make-doodad "radial-star" 490 2 10 12 "Green" #f 0 0)) = 500
;; (check-vx (make-doodad "radial-star" 0 2 -10 12 "Green" #f 0 0)) = 10
;; STRATEGY: Use template for Doodad on dood
(define (next-vx dood)
  (cond
     [(x-in-range? dood) (doodad-vx dood)]
     [(x-below-range? dood) ( * -1 (doodad-vx dood))]
     [(x-above-range? dood) ( * -1 (doodad-vx dood))]))

;; check-vy: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of vy for Doodad dood
;; EXAMPLE:
;; (check-vy (make-doodad "radial-star" 490 2 10 12 "Green" #f 0 0)) = 14
;; (check-vy (make-doodad "radial-star" 0 -2 -10 -12 "Green" #f 0 0)) = 14
;; STRATEGY: Use template for Doodad on dood
(define (next-vy dood)
  (cond
     [(y-in-range? dood) (doodad-vy dood)]
     [(y-below-range? dood)( * -1 (doodad-vy dood))]
     [(y-above-range? dood) ( * -1 (doodad-vy dood))]))

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

;; x-in-range? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: weather the sum of x and vx component of given Doodad is within
;;          limit
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (x-in-range? dood)
  (and (> (add-x-vx dood) 0) (< (add-x-vx dood) X-MAX)))

;; y-below-range? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: weather the sum of y and vy component of given Doodad is below
;;          limit
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (x-below-range? dood)
  (<= (add-x-vx dood) 0))

;; y-above-range? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: weather the sum of y and vy component of given Doodad is above
;;          limit
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (x-above-range? dood)
  (>= (add-x-vx dood) X-MAX))

;; y-in-range? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: weather the sum of y and vy component of given Doodad is within
;;          limit
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (y-in-range? dood)
  (and (> (add-y-vy dood) 0)(< (add-y-vy dood) Y-MAX)))

;; y-below-range? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: weather the sum of y and vy component of given Doodad is below limit
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (y-below-range? dood)
  (<= (add-y-vy dood) 0))

;; y-above-range? : Doodad -> Boolean
;; GIVEN: a Doodad
;; RETURNS: weather the sum of y and vy component of given Doodad is above limit
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (y-above-range? dood)
  (>= (add-y-vy dood) Y-MAX))

;; add-x-vx: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: sum of x and vx component of given Doodad
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on dood
(define (add-x-vx dood)
  (+ (doodad-x dood) (doodad-vx dood)))

;; add-y-vy: Doodad -> Integer
;; GIVEN: a Doodad
;; RETURNS: sum of y and yv component of given Doodad
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on dood
(define (add-y-vy dood)
  (+ (doodad-y dood) (doodad-vy dood)))

;; next-color: Doodad -> String 
;; GIVEN: Current color of Doodad as a string
;; RETURNS: Next color that should follow color c
;; EXAMPLE:
;;   (next-color "Green") = "Blue"
;;   (next-color "Blue") = "Gold"
;; STRATEGY: Use template for Dodad on dood
(define (next-color dood)
  (next-color-for-color (doodad-color dood)))

;; next-color-for-color: String -> String
;; GIVEN: color as String
;; RETURNS: color that should follow given color
;; EXAMPLE:
;; STRATEGY: Break into cases based on c
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

;; world-after-key-event: World KeyEvent -> World
;; GIVEN: a World and a KeyEvent 
;; RETURNS: a World that should follow given world after given KeyEvent 
;; EXAMPLE:
;; STRATEGY: Break into cases based on kev
(define (world-after-key-event w kev)
  (cond
    [(is-pause-key-event? kev) (world-with-paused-toggled w)]
    [(is-q-key-event? kev) (world-with-q-pressed w)]
    [(is-t-key-event? kev) (world-with-t-pressed w)]
    [(is-c-key-event? kev) (world-with-c-pressed w)]
    [(is-dot-key-event? kev) (world-with-dot-pressed w)]
    [else w]))

;; is-pause-key-event? KeyEvent -> Boolean
;; GIVEN: a KeyEvent 
;; RETURNS: weather given KeyEvent is " "
;; EXAMPLE:
;; STRATEGY: combine simpler functions 
(define (is-pause-key-event? ke)
  (key=? ke " "))

;; is-q-key-event? KeyEvent -> Boolean
;; GIVEN: a KeyEvent 
;; RETURNS: weather given KeyEvent is "q"
;; EXAMPLE:
;; STRATEGY: combine simpler functions 
(define (is-q-key-event? ke)
  (key=? ke "q"))

;; is-t-key-event? KeyEvent -> Boolean
;; GIVEN: a KeyEvent 
;; RETURNS: weather given KeyEvent is "t"
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (is-t-key-event? ke)
  (key=? ke "t"))

;; is-dot-key-event?: KeyEvent -> Boolean
;; GIVEN: a KeyEvent 
;; RETURNS: weather given KeyEvent is "."
;; EXAMPLE:
;; STRATEGY: combine simpler functions
(define (is-dot-key-event? ke)
  (key=? ke "."))

;; is-c-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: weather the given KeyEvent is "c"
;; EXAMPLE:
;; STRATEGY: Combine simpler functions
(define (is-c-key-event? ke)
  (key=? ke "c"))

;; world-with-dot-pressed : World -> World
;; GIVEN: a World
;; RETURNS:a World that should follow given World after press of "." key
;; EXAMPLE:
;; STRATEGY: Use template for World on w
(define (world-with-dot-pressed w)
  (make-world
   (remove-oldest-doodad (world-doodads-star w))
   (remove-oldest-doodad (world-doodads-square w))
   (world-paused? w)
   (world-dotx w)
   (world-doty w)
   (doodad-vx (new-star w))
   (doodad-vy (new-star w))
   (world-previous-square-vx w)
   (world-previous-square-vy w)))

;; oldest doodad is always at the start of the list
;; remove-oldest-doodad: ListOfDoodad -> ListOfDoodad
;; GIVEN: a ListOfDoodad
;; RETURNS: a ListOfDoodad like given but with oldest Doodads removed
;; EXAMPLE:
;; STRATEGY: Use template for ListOfDoodad on doods
(define (remove-oldest-doodad doods)
  (cond
    [(empty? doods) empty]
    [else (remove-oldest-doodads-helper doods (get-oldest-doodad-age doods))]))

;; remove-oldest-doodads-helper: ListOfDoodad Integer -> ListOfDoodad
;; GIVEN: a ListOfDoodad and age of oldest Doodad
;; RETURNS: a list like given ListOfDoodad with oldest Doodad removed
;; EXAMPLE:
;; STRATEGY: Use template for ListOfDoodad on doods
(define (remove-oldest-doodads-helper doods age)
  (cond
    [(empty? doods) empty]
    [(= age  (doodad-age (first doods)))  (remove-oldest-doodads-helper (rest doods) age) ]
    [else (cons (first doods) (remove-oldest-doodads-helper (rest doods) age))]))

;; get-oldest-doodad-age: ListOfDoodads -> Integer
;; GIVEN: a ListOfDoodad 
;; RETURNS: age of oldest Doodad
;; EXAMPLE:
;; STRATEGY: Use template for ListOfDoodad on doods
(define (get-oldest-doodad-age doods)
  (cond
    [(empty? doods) empty]
    [else (doodad-age (first doods))]))

;;; contract
;;; GIVEN:
;;; RETURNS:
;;; EXAMPLE:
;;; STRATEGY: 
;(define (get-max lst)
;  (cond
;    [(empty? lst) empty]
;    [else (get-max-helper lst (first lst))]))
;
;;; contract
;;; GIVEN:
;;; RETURNS:
;;; EXAMPLE:
;;; STRATEGY: 
;(define (get-max-helper lst max)
;  (cond
;    [(empty? lst) empty]
;    [(= (length lst) 1) max]
;    [( > (first lst) max) (get-max-helper (rest lst) (first lst))]
;    [else (get-max-helper (rest lst) max)]))

;; world-with-paused-toggled
;; GIVEN:a World
;; RETURNS: a World just like the given with paused? toggled
;; EXAMPLE:
;; STRATEGY: Use template for World on w
(define (world-with-paused-toggled w)
  (make-world-with-paused w (not (world-paused? w))))

;; world-with-t-pressed : World -> World
;; GIVEN: a World 
;; RETURNS:a World that should follow the given World after a "q" key press
;; EXAMPLE:
;; STRATEGY: Use template for World on w
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

;; world-with-t-pressed : World -> World
;; GIVEN: a World 
;; RETURNS:a World that should follow the given World after a "t" key press
;; EXAMPLE:
;; STRATEGY: Use template for World on w
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

;; add-new-star : ListOfDoodad World -> ListOfDoodad
;; GIVEN: a ListOfDoodad of square Doodads and a World
;; RETURNS: a World with new square like Doodad added 
;; EXAMPLE:
;; STRATEGY: combine simpler functions
;; add the new square doodad at end of list
(define (add-new-square squares w)
  (append squares (list (new-square w)) ))


;; new-star : World -> Doodad
;; GIVEN: a World
;; RETURNS: a new square like Dodad 
;; EXAMPLE:
;; STRATEGY: use tempalte for World on w
(define (new-square w)
  (make-doodad TYPE-SQUARE 460 350  (* -1 (world-previous-square-vy w))
               (world-previous-square-vx w) GRAY false 0 0 0)) 


;; add-new-star : ListOfDoodad World -> ListOfDoodad
;; GIVEN: a ListOfDoodad of star like Doodads and a World
;; RETURNS: a World with new star like Doodad added 
;; EXAMPLE:
;; STRATEGY: combine simpler functions
;; add the new star doodad at end of list
(define (add-new-star stars w)
  (append stars (list (new-star w))))

;; new-star : World -> Doodad
;; GIVEN: a World
;; RETURNS: a new star like Dodad 
;; EXAMPLE:
;; STRATEGY: use tempalte for World on w
(define (new-star w)
  (make-doodad TYPE-STAR 125 120 (* -1 (world-previous-star-vy w))
               (world-previous-star-vx w) GOLD false 0 0 0))

;; world-with-c-pressed: World -> World 
;; GIVEN: a World 
;; RETURNS: a World that should follow given World after "c" key press
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on dood
(define (world-with-c-pressed w)  
  (make-world
   (find-selected-doodads (world-doodads-star w))
   (find-selected-doodads (world-doodads-square w))
   (world-paused? w)
   (world-dotx w)
   (world-doty w)
   (doodad-vx (new-star w))
   (doodad-vy (new-star w))
   (world-previous-square-vx w)
   (world-previous-square-vy w)))

;; doodad-with-next-color: Doodad
;; GIVEN: a Doodad
;; RETURNS: next color for given Doodad
;; EXAMPLE:
;; STRATEGY:  Use template for Doodad on dood
(define (doodad-with-next-color dood)
  (make-doodad
      (doodad-type dood)
      (doodad-x dood)
      (doodad-y dood)
      (doodad-vx dood)
      (doodad-vy dood)
      (next-color dood)
      (doodad-selected? dood)
      (doodad-x-offset dood)
      (doodad-y-offset dood)
      (doodad-age dood)))

;; find-selected-doodads : ListOfDood -> ListOfDood
;; GIVEN: a ListOfDood
;; RETURNS: a ListOfDood
;; WHERE: all Doodads are selected 
;; EXAMPLE:
;; STRATEGY: Use template for ListOfDood on doods
(define (find-selected-doodads doods)
  (cond
    [(empty? doods) empty]
    [(doodad-selected? (first doods))
     (cons (doodad-with-next-color(first doods)) (find-selected-doodads (rest doods)) )]
    [(not (doodad-selected? (first doods)))
     (cons (first doods) (find-selected-doodads (rest doods)) )]
    [else (find-selected-doodads (rest doods))]))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Mouse event handling                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; world-after-mouse-event : World Integer Integer MouseEvent -> World
;; GIVEN: a world and a description of a mouse event
;; RETURNS: the world that should follow the given mouse event
;; (define UNPAUSED-WORLD (make-world
;;   (make-doodad "radial-star" 500 80 -10 12 "Green" #false 0 0)
;;   (make-doodad "square" 500 80 -10 12 "Khaki" #false 0 0) #false 0 0))
;;
;; (world-after-mouse-event UNPAUSED-WORLD 100 100 "drag")
;;                 (make-world (make-doodad "radial-star" 500 80 -10 12 "Green"
;;                                          #f 0 0)
;;                             (make-doodad "square" 500 80 -10 12 "Khaki"
;;                                          #f 0 0) #f 100 100) "")
;; STRATEGY: use template for World on w
(define (world-after-mouse-event w mx my mev)
  (make-world
    (doodads-after-mouse-event (world-doodads-star w) mx my mev)
    (doodads-after-mouse-event (world-doodads-square w) mx my mev)
    (world-paused? w)
    mx my
    (world-previous-star-vx w) (world-previous-star-vy w)
    (world-previous-square-vx w) (world-previous-square-vy w)))

;; doodads-after-mouse-event: ListOfDoodad Integer Integer Integer
;;   -> ListOfDood
;; GIVEN: a ListOfDoodad and coordinates of mouse pointer after click and mouse
;;        event
;; RETURNS: a ListOfDoodad following given mouse event
;; EXAMPLE:
;; STRATEGY: Use template for ListOfDoodad on doods
(define (doodads-after-mouse-event doods mx my mev)
  (cond
    [(empty? doods) empty]
    [else (cons
           (doodad-after-mouse-event (first doods) mx my mev)
           (doodads-after-mouse-event (rest doods) mx my mev))]))

;; doodad-after-mouse-event : Doodad Integer Integer MouseEvent -> Doodad
;; GIVEN: Doodad, current co-ordinates of mouse and description of mouse event
;; RETURNS: The Doodad that should follow the current Doodad
;; EXAMPLE:
;;  (doodad-after-mouse-event (make-doodad "radial-star" 500 80 -10 12
;;                            "Green" #false 0 0) 100 100 "enter") =
;;  (make-doodad "radial-star" 500 80 -10 12 "Green" #false 0 0)
;;
;; STRATEGY:Divide into cases based on mouse event
(define (doodad-after-mouse-event dood mx my mev)
  (cond
    [(mouse=? mev "button-down") (doodad-after-button-down dood mx my)]
    [(mouse=? mev "drag") (doodad-after-drag dood mx my)]
    [(mouse=? mev "button-up") (doodad-after-button-up dood)]
    [else dood]))

;; doodad-after-button-down : Doodad Integer Integer -> Doodad
;; GIVEN: Doodad, curren mouse co-ordinates 
;; RETURNS: The Doodad that should follow the current Doodad after mouse
;;          button down event
;; EXAMPLES: Available in comments
;; STRATEGY:Use template for Doodad on dood
(define (doodad-after-button-down dood mx my)
  (if (in-doodad? dood mx my)
      (make-doodad (doodad-type dood) (doodad-x dood) (doodad-y dood)
                   (doodad-vx dood) (doodad-vy dood) (doodad-color dood) true
                   (get-x-offset (doodad-x dood) mx)
                   (get-y-offset (doodad-y dood) my) 0) dood))

;; doodad-after-drag : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad, current co-ordinates of mouse
;; RETURNS: the Doodad following a drag at the given location
;; EXAMPLES: Available in comments
;; STRATEGY: Use template for Doodad on dood
(define (doodad-after-drag dood mx my)
  (if (doodad-selected? dood)
      (make-doodad (doodad-type dood) (- mx (doodad-x-offset dood))
                   (- my (doodad-y-offset dood)) (doodad-vx dood) (doodad-vy dood)
                   (doodad-color dood) true (doodad-x-offset dood) (doodad-y-offset dood) 0)
      dood))

;; doodad-after-button-up : Doodad -> Doodad
;; GIVEN: a Doodad 
;; RETURNS: the Doodad following a button-up at the given location
;; STRATEGY: Use template for Doodad on dood
(define (doodad-after-button-up dood)
  (if (doodad-selected? dood)
      (make-doodad (doodad-type dood) (doodad-x dood) (doodad-y dood)
                   (doodad-vx dood) (doodad-vy dood) (doodad-color dood) false
                   (doodad-x-offset dood) (doodad-y-offset dood) 0)
      dood))

;; in-doodad? : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and co-ordinates of a point
;; RETURNS true iff the given coordinate is inside the bounding box of
;; the given Doodad.
;; EXAMPLES: see tests below
;; STRATEGY: Use template for Doodad on dood
(define (in-doodad? dood x y)
  (cond
    [(string=? (doodad-type dood) TYPE-STAR) (in-star? dood x y)]
    [(string=? (doodad-type dood) TYPE-SQUARE) (in-square? dood x y)]))

;; in-doodad? : Doodad Integer Integer -> Doodad
;; GIVEN: a square Doodad and co-ordinates of a point
;; RETURNS true iff the given coordinate is inside the bounding box of
;; the given square Doodad.
;; EXAMPLES: 
;; STRATEGY: Use template for Doodad on dood
(define (in-square? dood x y)
  (and
    (<= 
      (- (doodad-x dood) HALF-SQUARE-WIDTH)
      x
      (+ (doodad-x dood) HALF-SQUARE-WIDTH))
    (<= 
      (- (doodad-y dood) HALF-SQUARE-HEIGHT)
      y
      (+ (doodad-y dood) HALF-SQUARE-HEIGHT))))

;; in-doodad? : Doodad Integer Integer -> Doodad
;; GIVEN: a star Doodad and co-ordinates of a point
;; RETURNS true iff the given coordinate is inside the bounding box of
;; the given star Doodad.
;; EXAMPLES: 
;; STRATEGY: Use template for Doodad on dood
(define (in-star? dood x y)
  (<=
   (sqrt (+
          (* (- x (doodad-x dood)) (- x (doodad-x dood)) )
          (* (- y (doodad-y dood)) (- y (doodad-y dood)) )))
   STAR-OUTTER-RADIUS ))

;; get-x-offset: Integer Integer -> Integer
;; GIVEN: current x co-ordinate of Doodad center and x-coordinate of
;;        mouse pointer
;; RETURNS: Distance between x-cordinate of center of Doodad and
;;        clicked location
;; STRATEGY: Combine simpler functions
(define (get-x-offset x mx)
  (- mx x)
)

;; get-x-offset: Integer Integer -> Integer
;; GIVEN: current y co-ordinate of Doodad center and x-coordinate of
;;        mouse pointer
;; RETURNS: Distance between y-cordinate of center of Doodad and
;;        clicked location
;; STRATEGY: Combine simpler functions
(define (get-y-offset y my)
  (- my y)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Drawing functions                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-to-scene : World -> Scene
;; GIVEN: a World
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: Available in tests
;; STRATEGY: Use template for World on w and combine simpler functions
(define (world-to-scene w)
  (place-stars
   (world-doodads-star w)
    (draw-squares w)
    (world-dotx w) (world-doty w)
   ))

;; draw-squares: World -> Scene
;; GIVEN: a World
;; RETURNS: a Scene with squares Doodads from given World drawn on it
;; EXAMPLE:
;; STRATEGY: Use template for World on w
(define (draw-squares w)
  (place-squares
   (world-doodads-square w) EMPTY-CANVAS (world-dotx w) (world-doty w)))

;; place-squares: ListOfDoodad Scene Integer Integer -> Scene
;; GIVEN: a ListOfDoodad, a Scene to draw on and coordinates for x, y of black
;;         dot
;; RETURNS: a Scene like original with given star like Doodad printed on it
;; EXAMPLE: 
;; STRATEGY: Use template for ListOfDoodad on stars 
(define (place-stars stars scene dotx doty)
  (cond
    [(empty? stars) scene]
    [else (place-stars
           (rest stars)
           (place-star (first stars) scene dotx doty)
           dotx doty)]))

;; place-star : Doodad Scene Integer Integer -> Scene
;; GIVEN: a Doodad and Scene on which this Doodad is to be drawn and
;;        x,y coordinates of dot to be displayed on Doodad 
;; RETURNS: a scene like the given one, but with the given star like
;;          Doodad painted on it
;; EXAMPLE: 
;; STRATEGY: Use template for Doodad on star and use template for World on w
(define (place-star star scene dotx doty)
  (cond
    [(doodad-selected? star)
     (draw-doodad-with-dot star (draw-star-helper star scene) dotx doty)]
    [else (draw-star-helper star scene)]))

;; place-squares: ListOfDoodad Scene Integer Integer -> Scene
;; GIVEN: a ListOfDoodad, a Scene to draw on and coordinates for x, y of black dot
;; RETURNS: a Scene like original with given squares Doodad printed on it
;; EXAMPLE: 
;; STRATEGY: Use template for ListOfDoodad on squares 
(define (place-squares squares scene dotx doty)
  (cond
    [(empty? squares) scene]
    [else (place-squares
           (rest squares)
           (place-square (first squares) scene dotx doty)
           dotx doty) ]))

;; place-square : Doodad Scene Integer Integer -> Scene
;; GIVEN: a Doodad and Scene on which this Doodad is to be drawn and
;;        x,y coordinates of dot to be displayed on Doodad 
;; RETURNS: a scene like the given one, but with the given Doodad painted on it
;; EXAMPLE: 
;; STRATEGY: Use template for Doodad on sq and use template for World on w
(define (place-square sq scene dotx doty)
  (cond
    [(doodad-selected? sq)
     (draw-doodad-with-dot sq (draw-square-helper sq scene) dotx doty)]
    [else (draw-square-helper sq scene)])
  )

;; draw-doodad-with-dot: Doodad Scene Integer Integer
;; GIVEN: A Doodad, a Scene to paint on, coordinates of black dot
;;        to be displayed on Doodad
;; RETURNS: A Scene like the original with a dot printed on it
;; EXAMPLE:
;; STRATEGY: Combine simpler functions
(define (draw-doodad-with-dot dood scene dotx doty)
  (place-image (circle 3 "solid" "black") dotx doty scene))

;; draw-star-helper: Doodad Scene -> Scene
;; GIVEN: a star like Doodad and a Scene
;; RETURNS: a Scene like the original with given Doodad printed on it
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on star
(define (draw-star-helper star scene)
  (place-image
    (radial-star 8 10 50 "solid" (doodad-color star))
    (doodad-x star) (doodad-y star)
    scene))

;; draw-square-helper: Doodad Scene -> Scene
;; GIVEN: A square Doodad and a Scene
;; RETURNS: A Scene like the original with given Doodad printed on it
;; EXAMPLE:
;; STRATEGY: Use template for Doodad on sq
(define (draw-square-helper sq scene)
  (place-image
    (square 71 "solid" (doodad-color sq))
    (doodad-x sq) (doodad-y sq)
    scene))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;