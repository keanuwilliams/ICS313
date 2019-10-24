;;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-
;;;; Name: Keanu Williams      Date: October 23rd, 2019
;;;; Course: ICS313            Assignment: 4
;;;; File: kwill304C.lisp

(defvar +ID+ "Keanu Williams")

;; the different statements to be printed for each location
(defparameter *nodes* '((living-room (you are in the living-room.
                            a wizard is snoring loudly on the couch.))
                        (garden (you are in a beautiful garden.
                            there is a well in front of you.))
                        (attic (you are in the attic.
                            there is a giant welding torch in the corner.))))

;; checks if location exists in *nodes* and if it does it prints the statement
(defun describe-location (location nodes)
   (cadr (assoc location nodes)))

;; shows how the locations relate with each other
(defparameter *edges* '((living-room (garden west door)  
                                     (attic upstairs ladder))
                        (garden (living-room east door))
                        (attic (living-room downstairs ladder))))

;; makes a message depending on which location the player is at
;; about the surrounding locations to that current area
(defun describe-path (edge)
  `(there is a ,(caddr edge) going ,(cadr edge) from here.))

;; does the same thing as above but creates multiple messages
;; if there are multiple locations nearby
(defun describe-paths (location edges)
  (apply #'append (mapcar #'describe-path (cdr (assoc location edges)))))

;; different objects available in the map
(defparameter *objects* '(bucket chain frog whiskey))

;; the locations of the available objects in the map
(defparameter *object-locations* '((whiskey living-room)
                                   (bucket living-room)
                                   (chain garden)
                                   (frog garden)))

;; places objects in their location if not it will not be placed there
(defun objects-at (loc objs obj-loc)
   (labels ((is-at (obj)
              (eq (cadr (assoc obj obj-loc)) loc)))
       (remove-if-not #'is-at objs)))

;; if an object is at a location, it will display a message saying it is on the floor
(defun describe-objects (loc objs obj-loc)
   (labels ((describe-obj (obj)
                `(you see a ,obj on the floor.)))
      (apply #'append (mapcar #'describe-obj (objects-at loc objs obj-loc)))))

(defparameter *location* 'living-room) ; the starting location

;; prints out the message to the player about the current location and the environment
(defun look ()
  (append (describe-location *location* *nodes*)
          (describe-paths *location* *edges*)
          (describe-objects *location* *objects* *object-locations*)))

;; allows the player to walk to different locations from their current location
(defun walk (direction)
  (labels ((correct-way (edge)
             (eq (cadr edge) direction)))
    (let ((next (find-if #'correct-way (cdr (assoc *location* *edges*)))))
      (if next 
          (progn (setf *location* (car next)) 
                 (look))
          '(you cannot go that way.)))))

;; allows the player to pick up the object and place it in its inventory
(defun pickup (object)
  (cond ((member object (objects-at *location* *objects* *object-locations*))
         (push (list object 'body) *object-locations*)
         `(you are now carrying the ,object))
	  (t '(you cannot get that.))))

;; prints out to the user their inventory
(defun inventory ()
  (cons 'items- (objects-at 'body *objects* *object-locations*)))

;; checks if the user has an object
(defun have (object) 
    (member object (cdr (inventory))))

;; keep playing the game unless the player quits
(defun game-repl ()
    (let ((cmd (game-read)))
        (unless (eq (car cmd) 'quit)
          (if (or (eq (car cmd) 'help) (eq (car cmd) 'h) (eq (car cmd) '?)) (help)
            (game-print (game-eval cmd)))
            (game-repl))))

;; helper for the game-repl function
(defun game-read ()
    (let ((cmd (read-from-string (concatenate 'string "(" (read-line) ")"))))
         (flet ((quote-it (x)
                    (list 'quote x)))
             (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))

(defparameter *allowed-commands* '(look walk pickup inventory)) ; the allowed commmands in game

;; checks if the player input a proper command
(defun game-eval (sexp)
    (if (member (car sexp) *allowed-commands*)
        (eval sexp)
        '(i do not know that command. type help h or ? to list the commands.)))

;; properly formats the statements
(defun tweak-text (lst caps lit)
  (when lst
    (let ((item (car lst))
          (rest (cdr lst)))
      (cond ((eql item #\space) (cons item (tweak-text rest caps lit)))
            ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
            ((eql item #\") (tweak-text rest caps (not lit)))
            (lit (cons item (tweak-text rest nil lit)))
            (caps (cons (char-upcase item) (tweak-text rest nil lit)))
            (t (cons (char-downcase item) (tweak-text rest nil nil)))))))

;; prints the statements to the user
(defun game-print (lst)
    (princ (coerce (tweak-text (coerce (string-trim "() " (prin1-to-string lst)) 'list) t nil) 'string))
    (fresh-line))

;; lists the allowed commands in the game
(defun help ()
  (format t "Commands:~%")
  (format t "look             -- prints the description of your current location.~%")
  (format t "walk [direction] -- walk in the direction specified.~%")
  (format t "pickup [item]    -- adds an item to your inventory.~%")
  (format t "inventory        -- lists the items in your inventory.~%")
)

