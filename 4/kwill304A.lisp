;;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-
;;;; Name: Keanu Williams      Date: October 23rd, 2019
;;;; Course: ICS313            Assignment: 4
;;;; File: kwill304A.lisp

(defvar +ID+ "Keanu Williams")

;; the different statements to be printed for each location
(defparameter *nodes* '((living-room (you are in the living-room.
                            a wizard is snoring loudly on the couch.))
                        (garden (you are in a beautiful garden.
                            there is a well in front of you.))
                        (attic (you are in the attic.
                            there is a giant welding torch in the corner.))))

;; macro from creating new location
(defmacro new-location (loc des)
  `(cond
    ((not (symbolp ,loc))
      (format t "The location ~A must be a symbol.~%" ,loc)
    )
    ((not (listp ,des))
      (format t "The description ~A must be a list.~%" ,des)
    )
    ((location-exists ,loc)
      (format t "The location ~A already exists.~%" ,loc)
    )
    (t
      (push (list ,loc ,des) *nodes*)
    )
  )
)

;; macro for creating a new object
(defmacro new-object (obj loc)
  `(cond
    ((or (not (symbolp ,obj)) (not (symbolp ,loc)))
      (format t "Parameters must be symbols.~%")
    )
    ((not (location-exists ,loc))
      (format t "The location ~A does not exist.~%" ,loc)
    )
    ((object-exists ,obj)
      (format t "The object ~A already exists.~%" ,obj)
    )
    (t
      (push ,obj *objects*)
      (push (list ,obj ,loc) *object-locations*)
    )
  )
)

;; macro for creating a new path between two locations
(defmacro new-path (src dest dir port &optional two-way)
  `(cond
    ((and (not (symbolp ,src)) (not (symbolp ,dest)) (not (symbolp ,dir)) (not (symbolp ,port)))
      (format t "Parameters must be symbols.~%")
    )
    ((not (location-exists ,src))
      (format t "The location ~A does not exist.~%" ,src)
    )
    ((not (location-exists ,dest))
      (format t "The location ~A does not exist.~%" ,dest)
    )
    ((not (get-opp-dir ,dir))
      (format t "~A not a correct direction.~%" ,dir)
    )
    ((member ,dir (flatten (cdr (assoc ,src *edges*))))
      (format t "Unable to create path for that direction.")
    )
    ((assoc ,dest (cdr (assoc ,src *edges*)))
      (format t "Path from ~A to ~A already exists.~%" ,src ,dest)
    )
    (t
      (cond
        ((assoc ,src *edges*)
          (push (list ,dest ,dir ,port) (cdr (assoc ,src *edges*)))
        )
        (t
          (push (list ,src (list ,dest ,dir ,port)) *edges*)
        )
      )
     (if (not (null ,two-way)) (new-path ,dest ,src (get-opp-dir ,dir) ,port))
    )
  )
)

;; flattens a list
(defun flatten (str)
  (cond
    ((null str) nil)
    ((atom str) (list str))
    (t (mapcan #'flatten str))))

;; checks if location exists 
(defun location-exists (loc)
  (cond
    ((assoc loc *nodes*) t)
    (t ())))

;; checks if object exists
(defun object-exists (obj)
  (cond
    ((member obj *objects*) t)
    (t ())))

;; returns the opposite direction
(defun get-opp-dir (dir)
  (cond
    ((eq dir 'upstairs) 'downstairs)
    ((eq dir 'downstairs) 'upstairs)
    ((eq dir 'up) 'down)
    ((eq dir 'down) 'up)
    ((eq dir 'left) 'right)
    ((eq dir 'right) 'left)
    ((eq dir 'north) 'south)
    ((eq dir 'northeast) 'southwest)
    ((eq dir 'northwest) 'southeast)
    ((eq dir 'southwest) 'northeast)
    ((eq dir 'southeast) 'northwest)
    ((eq dir 'west) 'east)
    ((eq dir 'south) 'north)
    ((eq dir 'east) 'west)
    (t nil)))

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
            (game-print (game-eval cmd))
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
        '(i do not know that command.)))

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

