;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)
(require "extras.rkt")
(check-location "04" "q1.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            DATA DEFINITIONS                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Two moving draggable Doodads, they bounce off of the corner of rectangular
;; enclosure.
;; Animation can be paused using space key
;; Doodads can be dragged 
;; starts with (animation 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       DATA DEFINITIONS                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-struct world (star square is-paused? dotx doty))

;; A World is a (make-world Doodad Doodad Boolean Integer Integer)
;; star is Doodad shaped like a radial star
;; square is Doodad shaped like a square
;; is-paused? describes whether or not the world is paused
;; dotx: x co-ordinate for center of black dot
;; doty: y co-ordinate for center of black dot

;; template:
;; world-fn : World -> ??
;; (define (world-fn w)
;;   (... (world-star w) (world-square w) (world-is-paused? w) (world-dotx w)
;;     (world-doty w)))

(define-struct doodad (type x y vx vy color selected? xd yd))

;; A Doodad is:
;; -- (define-struct doodad (String Integer Integer Integer Integener String
;;      Boolean Integer Integer))
;; INTERPRETATION:
;;   x: x-coordinate of Doodad
;;   y: x-coordinate of Doodad
;;   vx: number of pixels the Doodad moves on each tick in the x direction
;;   vy: number of pixels the Doodad moves on each tick in the y direction
;;   color: color of this Doodad as a String
;;   selected?: describes whether or not the Doodad is selected.
;;   xd: Difference of x co-cordinate from center of Doodad
;;   yd: Difference of y co-cordinate from center of Doodad

;; EXAMPLE:
;;  (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0) =
;;  (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0)
;;
;;  (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0) =
;;  (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0)
;;
;; TEMPLATE:
;; doodad-fn : Doodad -> ??
;; (define (doodad-fn dood)
;;  (... (doodad-type dood) (doodad-x dood) (doodad-y dood) (doodad-vx dood)
;;       (doodad-vy dood) (doodad-color dood) (doodad-selected? dood)
;;       (doodad-xd dood) (doodad-yd dood) ))

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

(define HALF-DOODAD-HEIGHT 71/2)
(define HALF-DOODAD-WIDTH  71/2)
(define X-MAX 661)
(define Y-MAX 449)

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

;; initial-world : Any -> World
;; GIVEN: any value (ignored)
;; RETURNS: the initial world specified for the animation
;; EXAMPLE: (initial-world -174) =
;; (make-world
;;   (make-doodad "radial-star" 125 120 10 12 "Gold" #false 0 0)
;;   (make-doodad "square" 460 350 -13 -9 "Gray" #false 0 0) #false 0 0)
;; STRATEGY: Combine simpler functions
(define (initial-world v)
  (make-world
    (make-doodad TYPE-STAR STAR-START-X STAR-START-Y STAR-VX STAR-VY
                 GOLD false 0 0)
    (make-doodad TYPE-SQUARE SQUARE-START-X SQUARE-START-Y SQUARE-VX SQUARE-VY
                 GRAY false 0 0) 
    false 0 0))

;; world-paused? : World -> Boolean
;; GIVEN: a World
;; RETURNS: true iff the World is paused
;; EXAMPLE:
;;       (define TEST-WORLD
;;         (make-world (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0)
;;         (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0) #f 0 0))
;; (world-paused? TEST-WORLD) = false
;;
;; STRATEGY: Use template for World on w
(define (world-paused? w)
  (world-is-paused? w))

;; world-doodad-star : World -> Doodad
;; GIVEN: a World
;; RETURNS: the star-like Doodad of the World
;; EXAMPLE:
;;       (define TEST-WORLD
;;         (make-world (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0)
;;         (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0) #f 0 0))
;;
;;  (world-doodad-star TEST-WORLD) = (make-world
;;                                     (make-doodad "radial-star"
;;                                        500 80 -10 12 "Green" #f 0 0)
;;
;; STRATEGY: Use template for World on w
(define (world-doodad-star w)
  (world-star w))

;; world-doodad-square : World -> Doodad
;; GIVEN: a World
;; RETURNS: the square Doodad of the World
;; EXAMPLE:
;;       (define TEST-WORLD
;;         (make-world (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0)
;;         (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0) #f 0 0))
;;
;;  (world-doodad-square TEST-WORLD) = (make-doodad "square" 500 80 -10 12
;;                                        "Khaki" #f 0 0) #f 0 0))
;; STRATEGY: Use template for World on w
(define (world-doodad-square w)
  (world-square w))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                     MOUSE EVENT HANDLING                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
    (doodad-after-mouse-event (world-star w) mx my mev)
    (doodad-after-mouse-event (world-square w) mx my mev)
    (world-paused? w)
    mx my))

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
    [(mouse=? mev "button-up") (doodad-after-button-up dood mx my)]
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
                   (get-xd (doodad-x dood) mx)
                   (get-yd (doodad-y dood) my)) dood))

;; doodad-after-drag : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad, current co-ordinates of mouse
;; RETURNS: the Doodad following a drag at the given location
;; EXAMPLES: Available in comments
;; STRATEGY: Use template for Doodad on dood
(define (doodad-after-drag dood mx my)
  (if (doodad-selected? dood)
      (make-doodad (doodad-type dood) (- mx (doodad-xd dood))
                   (- my (doodad-yd dood)) (doodad-vx dood) (doodad-vy dood)
                   (doodad-color dood) true (doodad-xd dood) (doodad-yd dood))
      dood))

;; doodad-after-button-up : Doodad Integer Integer -> Doodad
;; RETURNS: the Doodad following a button-up at the given location
;; STRATEGY: Use template for Doodad on dood
(define (doodad-after-button-up dood mx my)
  (if (doodad-selected? dood)
      (make-doodad (doodad-type dood) (doodad-x dood) (doodad-y dood)
                   (doodad-vx dood) (doodad-vy dood) (doodad-color dood) false
                   (doodad-xd dood) (doodad-yd dood))
      dood))

;; in-doodad? : Doodad Integer Integer -> Doodad
;; GIVEN: a Doodad and co-ordinates of a point
;; RETURNS true iff the given coordinate is inside the bounding box of
;; the given Doodad.
;; EXAMPLES: see tests below
;; STRATEGY: Use template for Doodad on dood
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


;; get-xd: Integer Integer -> Integer
;; GIVEN: current x co-ordinate of Doodad center and x-coordinate of
;;        mouse pointer
;; RETURNS: Distance between x-cordinate of center of Doodad and
;;        clicked location
;; STRATEGY: Combine simpler functions
(define (get-xd x mx)
  (- mx x)
)

;; get-xd: Integer Integer -> Integer
;; GIVEN: current y co-ordinate of Doodad center and x-coordinate of
;;        mouse pointer
;; RETURNS: Distance between y-cordinate of center of Doodad and
;;        clicked location
;; STRATEGY: Combine simpler functions
(define (get-yd y my)
  (- my y)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Drawing functions                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-to-scene : World -> Scene
;; GIVEN: a World
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: Available in tests
;; STRATEGY: Use template for World on w
(define (world-to-scene w)
  (place-star
    (world-star w)
    (place-square
      (world-square w)
      EMPTY-CANVAS w) w))

;; place-radial-star : Doodad Scene -> Scene
;; GIVEN: a Doodad and Scene onn which the Doodad is to be drawn, the World
;;        which contains this Doodad
;; RETURNS: a scene like the given one, but with the given Doodad painted
;;        on it.
;;
;; (define SELECTED-STAR
;;  (make-doodad TYPE-STAR 500 80 -10 12 "Green" true 0 0))
;;
;; (define UNPAUSED-WORLD-WITH-SELECTED-STAR
;;  (make-world SELECTED-STAR UNSELECTED-SQUARE false 500 80))
;;
;; (define SQUARE-UI
;;   (place-image (square 71 "solid" "Khaki") 500 80 EMPTY-CANVAS))
;;   (define DOT-WITH-SQUARE (place-image
;;                         (circle 3 "solid" "black") 500 80 SQUARE-UI))
;;
;; (place-star SELECTED-STAR EMPTY-CANVAS
;;                            UNPAUSED-WORLD-WITH-SELECTED-STAR) = SQUARE-UI
;;
;; STRATEGY: Use template for Doodad on star and use template for World on w
(define (place-star star scene w)
  (cond
    [(doodad-selected? star)
     (draw-doodad-with-dot star (draw-star-helper star scene) (world-dotx w)
                           (world-doty w))]
    [else (draw-star-helper star scene)]))

;; place-square : Doodad Scene -> Scene
;; GIVEN: a Doodad and Scene on which this Doodad is to be drawn 
;; RETURNS: a scene like the given one, but with the given Doodad painted on it
;; EXAMPLE: Use template for Doodad on sq and use template for World on w
;; STRATEGY: Combine simpler functions
(define (place-square sq scene w)
  (cond
    [(doodad-selected? sq)
     (draw-doodad-with-dot sq
                           (draw-square-helper sq scene)
                           (world-dotx w)
                           (world-doty w))]
    [else (draw-square-helper sq scene)])
  )

;; draw-doodad-with-dot: Doodad Scene Integer Integer -> Scene
;; GIVEN: a Doodad, a Scene on which the Doodad is to be drawn and dotx, doty
;;        are co-ordinates for small black to be drawn
;; RETURNS: a scene like the given one, but with the given Doodad and Black dot
;;          painted on it
;; STRATEGY: Combine simpler functions
(define (draw-doodad-with-dot dood scene dotx doty)
  (place-image (circle 3 "solid" "black") dotx doty scene))

;; draw-star-helper: Doodad Scene
;; GIVEN: Star like Doodad of the World
;; RETURNS: a Scene like original but given star-like Doodad and a small black
;;          circle print on it
;; STRATEGY: Use template for Doodad on dood
(define (draw-star-helper star scene)
  (place-image
    (radial-star 8 10 50 "solid" (doodad-color star))
    (doodad-x star) (doodad-y star)
    scene))

;; draw-square-helper: Doodad Scene
;; GIVEN: Star like Doodad of the World
;; RETURNS: a Scene like original but given square Doodad and a small black
;;          circle print on it
;; STRATEGY: Use template for Doodad on dood
(define (draw-square-helper sq scene)
  (place-image
    (square 71 "solid" (doodad-color sq))
    (doodad-x sq) (doodad-y sq)
    scene))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                        Key event handlers                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-key-event : World KeyEvent -> World
;; GIVEN: a world w
;; RETURNS: the world that should follow the given world after the given key
;; event. on space, toggle paused?-- ignore all others
;; EXAMPLES: Available in the tests
;; STRATEGY: Cases on whether the kev is a pause event
(define (world-after-key-event w kev)
  (cond
    [(is-pause-key-event? kev) (world-with-paused-toggled w)]
    [(is-c-key-event? kev) (world-with-next-color-for w)]
    [else w]))

;; world-with-paused-toggled : World -> World
;; GIVEN: a World
;; RETURNS: a world just like the given one, but with paused? toggled
;; STRATEGY: use template for World on w
(define (world-with-paused-toggled w)
  (make-world
   (world-star w)
   (world-square w)
   (not (world-paused? w)) 0 0))

;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
(define (is-pause-key-event? ke)
  (key=? ke " "))

;; world-with-next-color-for: World -> Color
;; GIVEN: a World
;; RETURNS: next Color as String for Doodad of the given world
;; STRATEGY: Use template for Doodad on dood and use teamplte for World on w
(define (world-with-next-color-for w)
  (make-world
   (make-doodad (doodad-type (world-star w)) (doodad-x (world-star w))
                (doodad-y (world-star w)) (doodad-vx (world-star w))
                (doodad-vy (world-star w))
                (next-color-if-selected (world-star w))
                (doodad-selected? (world-star w)) 0 0)
   (make-doodad (doodad-type (world-square w)) (doodad-x (world-square w))
                (doodad-y (world-square w))  (doodad-vx (world-square w))
                (doodad-vy (world-square w))
                (next-color-if-selected (world-square w))
                (doodad-selected? (world-square w)) 0 0)
   (world-paused? w) 0 0))


;; next-color-if-selected : Doodad -> Color
;; GIVEN: a Doodad
;; RETURNS: next Color as String for the given Doodad 
;; STRATEGY: Use template for Doodad on dood
(define (next-color-if-selected dood)
  (cond
    [(doodad-selected? dood) (next-color (doodad-color dood))]
    [else (doodad-color dood)]))

;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
;; STRATEGY: Combine simpler functions
(define (is-c-key-event? ke)
  (key=? ke "c"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       Tick handlers                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-tick : World -> World
;; GIVEN: any World that's possible for the animation
;; RETURNS: the World that should follow the given World after a tick
;; EXAMPLES: Available in comments
;; STRATEGY: Use template for world on w
(define (world-after-tick w)
  (if (world-paused? w)
    w
    (make-world
      (doodad-after-tick (world-star w))
      (doodad-after-tick (world-square w))
      (world-paused? w) 0 0)))

;; doodad-after-tick : Doodad -> Doodad
;; GIVEN: the state of a radial-star-doodad dood
;; RETURNS: the state of the given doodad after a tick if it were in an
;;          unpaused world.
;; EXAMPLE:
;; (define STAR-X-MAX
;;   (make-doodad "radial-star" 800 80 -10 12 "Green" #f 0 0))
;; (define STAR-X-MAX-AFTER
;;   (make-doodad "radial-star" 530 92 10 12 "Blue" #f 0 0))
;;
;; (doodad-after-tick STAR-X-MAX) = STAR-X-MAX-AFTER
;;
;; STRATEGY: use template for Doodad on dood
(define (doodad-after-tick dood)
  (cond
    [(doodad-selected? dood) dood]
    [else
     (make-doodad
      (doodad-type dood)
      (check-x dood)
      (check-y dood)
      (check-vx dood)
      (check-vy dood)
      (check-color dood)
      (doodad-selected? dood) 0 0)]))

;; check-x: Doodad -> Integer
;; GIVEN: a Doodad dood
;; RETURNS: new value of x for Doodad dood
;; EXAMPLE:
;; (check-x (make-doodad "radial-star" 490 -2 10 -12 "Green" #f 0 0)) = 510
;; (check-x (make-doodad "radial-star" 0 -2 -10 -12 "Green" #f 0 0)) = 10
;; STRATEGY: Use template for Doodad on dood
(define (check-x dood)
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
(define (check-y dood)
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
(define (check-vx dood)
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
(define (check-vy dood)
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

;; check-color: Doodad -> String 
;; GIVEN: Current color of Doodad
;; RETURNS: Next color that should follow current color
;; EXAMPLE:
;; (check-color (make-doodad "radial-star" 400 80 -10 12 "Green" #f 0 0))
;;   = Green
;; (check-color (make-doodad "radial-star" 800 80 -10 12 "Green" #f 0 0))
;;   = Blue
;; STRATEGY: Use template for Doodad on dood
(define (check-color dood)
  (cond
    [(core-bounce? dood) (next-color (doodad-color dood))]
    [else (doodad-color dood)]))

;; next-color: String -> String 
;; GIVEN: Current color of Doodad as a string
;; RETURNS: Next color that should follow color c
;; EXAMPLE:
;;   (next-color "Green") = "Blue"
;;   (next-color "Blue") = "Gold"
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; CONSTANTS FOR TEST:
(define RADIAL-STAR-IMAGE (radial-star 8 10 50 "solid" "gold"))
(define SQUARE-IMAGE (square 71 "solid" "gray"))

(define world-scene-at-beginning
  (place-image RADIAL-STAR-IMAGE 125 120
               (place-image SQUARE-IMAGE 460 350 EMPTY-CANVAS)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define UNSELECTED-STAR
  (make-doodad TYPE-STAR 500 80 -10 12 "Green" false 0 0))
(define SELECTED-STAR
  (make-doodad TYPE-STAR 500 80 -10 12 "Green" true 0 0))
(define UNSELECTED-SQUARE
  (make-doodad TYPE-SQUARE 500 80 -10 12 "Khaki" false 0 0))
(define SELECTED-SQUARE
  (make-doodad TYPE-SQUARE 500 80 -10 12 "Khaki" true 0 0))

(define UNPAUSED-WORLD
  (make-world UNSELECTED-STAR UNSELECTED-SQUARE false 0 0))
(define PAUSED-WORLD
  (make-world UNSELECTED-STAR UNSELECTED-SQUARE true 0 0))
(define UNPAUSED-WORLD-WITH-SELECTED-STAR
  (make-world SELECTED-STAR UNSELECTED-SQUARE false 500 80))
(define UNPAUSED-WORLD-WITH-SELECTED-SQUARE
  (make-world UNSELECTED-STAR SELECTED-SQUARE false 500 80))

(define UNPAUSED-WORLD-WITH-NEXT-COLOR-FOR-STAR
  (make-world (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0)
              (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0) #f 0 0))

(define UNPAUSED-WORLD-WITH-NEXT-COLOR-FOR-SQUARE
  (make-world (make-doodad "radial-star" 500 80 -10 12 "Green" #f 0 0)
              (make-doodad "square" 500 80 -10 12 "Khaki" #f 0 0) #f 0 0))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define STAR-X-MAX (make-doodad "radial-star" 800 80 -10 12 "Green" #f 0 0))
(define STAR-X-MAX-AFTER (make-doodad "radial-star" 530 92 10 12 "Blue" #f 0 0))

(define STAR-X-MIN (make-doodad "radial-star" -10 80 -10 12 "Green" #f 0 0))
(define STAR-X-MIN-AFTER (make-doodad "radial-star" 20 92 10 12 "Blue" #f 0 0))

(define STAR-Y-MAX
  (make-doodad "radial-star" 500 500 -10 12 "Green" #f 0 0))
(define STAR-Y-MAX-AFTER
  (make-doodad "radial-star" 490 384 -10 -12 "Blue" #f 0 0))

(define STAR-Y-MIN
  (make-doodad "radial-star" 500 -10 -10 12 "Green" #f 0 0))
(define STAR-Y-MIN-AFTER
  (make-doodad "radial-star" 490 2 -10 12 "Green" #f 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define SQUARE-X-MAX (make-doodad "square" 800 80 -10 12 "Khaki" #f 0 0))
(define SQUARE-X-MAX-AFTER (make-doodad "square" 530 92 10 12 "Orange" #f 0 0) )

(define UNPAUSED-WORLD-BEFORE-TICK
  (make-world STAR-X-MAX SQUARE-X-MAX false 0 0))

(define UNPAUSED-WORLD-AFTER-TICK
(make-world STAR-X-MAX-AFTER SQUARE-X-MAX-AFTER false 0 0))

(define STAR-UI (place-image
                 (radial-star 8 10 50 "solid" "green") 500 80 EMPTY-CANVAS))
(define DOT-WITH-STAR (place-image (circle 3 "solid" "black") 500 80 STAR-UI))

(define SQUARE-UI (place-image (square 71 "solid" "Khaki") 500 80 EMPTY-CANVAS))
(define DOT-WITH-SQUARE (place-image
                         (circle 3 "solid" "black") 500 80 SQUARE-UI))
