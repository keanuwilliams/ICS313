;;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-
;;;; Name: Keanu Williams      Date: September 20th, 2019
;;;; Course: ICS313            Assignment: 2
;;;; File: kwill302.lisp

(defvar +ID+ "Keanu Williams") ; for the ID function
(defconstant +alphabet-number+ ; for the ALPHABET function
'((1 a) (2 b) (3 c) (4 d) (5 e) (6 f) (7 g) (8 h) (9 i) (10 j) (11 k) (12 l) (13 m) (14 n) (15 o) (16 p) (17 q) (18 r) (19 s) (20 t) (21 u) (22 v) (23 w) (24 x) (25 y) (26 z)
))


;;ID FUNCTION
; Prints my name, given ICS course number (class), and given assignment number (assign).
(defun id (class assign)
  (cond
   ((not (integerp class))
    (format t "First parameter must be an integer.~%")
    () ; if first param != integer, return NIL and end
   )
   ((not (integerp assign))
    (format t "Second parameter must be an integer.~%")
    () ; if second param != integer, return NIL and end
   )
   (t (format t "Name: ~A~%Course: ICS~A~%Assignment # ~A~%"
       +ID+ class assign) 
   ()) ; After error checking print the id 
  ) 
)

;;ALTERNATE FUNCTION
; Given an item and a list and returns a list with the input item before each item in the list.
(defun alternate (item list)
  (cond
    ((not (listp list))
     (format t "Error in ALTERNATE function. Second parameter must be a list, but was ~A.~%"
      list)
     () ; if second param != list, return NIL and end
    )
    ((null list) ()) ; no items in list, return () 
    (t (cons item (cons (car list) (alternate item (cdr list))))
    ) ; add item + first of list to the result of recursion on rest of list
  )
)

;;ALPHABET FUNCTION
; Takes a list of integers in the 1-26 range and returns a list of the same length with the corresponding alphabet letter substituted for the integer.
(defun alphabet (list &optional (alphabet-list +alphabet-number+))
  (cond
    ((not (listp list)) ; if param is not a list
     (format t "Error in ALPHABET function. Parameter must be a list, but was given ~A.~%"
      list) ; print message and end
    )
    ((not (listp alphabet-list)) ; if alphabet-list is not a list
     (format t "Error in ALPHABET function. Optional second parameter must be a list, but was given ~A.~%"
      list) ; print message and end
    )
    ((null list) ()) ; no items in list, return ()
    ((null alphabet-list) ()) ; no items in list, return ()
    ((not (listp (car alphabet-list)))
     (format t "Error in ALPHABET function. Optional second paramter must be a list of item/value pairs.~%")
    )
    (t ; (let
       ; (c-num (caar alphabet-list)) ; local variables
       ; (c-let (cadar alphabet-list)))
       (cond 
         ((not (integerp (car list))) ; if item is not an integer
          (format t "Error in ALPHABET function. Item in list must be an integer, but was given ~A.~%"
          (car list))
         )
         ((> (car list) 26) ; item in list > 26
          (format t "Error in ALPHABET function. Item in list is greater than 26.~%")
         )
         ((< (car list) 1) ; item in list < 1
          (format t "Error in ALPHABET function. Item in list is less than 1.~%")
         )
         ((eq (caar alphabet-list) (car list)) ; if item is found in alphabet-list
          (cons (cadar alphabet-list) (alphabet (cdr list))) ; search next item
         )
         (t (alphabet list (cdr alphabet-list))) ; if not found yet keep searching through list
       )
    )
  )
)

;;TYPECHECK FUNCTION
; Takes a list and returns a list containing a list of the applicable types (in any order) for each item on the list.
(defun typecheck (list)
  (cond
    ((not (listp list)) ; if parameter is not a list
      (format t "Error in TYPECHECK function. Parameter must be a list.~%") ; print message
    ) 
    ((null list) ()) ; no items in list, return ()
    (t
      (setq tof (if (not (null (car list))) 't)) ; create variable so that nil wont be removed
      (cons (cons tof (remove nil (list          ; check the rest of the datatypes and make a list
        (if (listp (car list)) 'list)            ; while adding the variable above to the list
        (if (stringp (car list)) 'string)
        (if (symbolp (car list)) 'symbol)
        (if (numberp (car list)) 'number)
      ))) (typecheck(cdr list))) ; recurse through rest of list
    )
  )
)

;;FILTERTYPE FUNCTION
; Takes a datatype name (from TYPECHECK) and a list, then returns the list with all the items of that type removed.
(defun filtertype (type list)
  (cond
    ((not (listp list)) ; if parameter is not a list
      (format t "Error in FILTERTYPE function. Second parameter must be a list.~%") ; print message
    )
    ((null list) ()) ; no items in list, return ()
    ((not (types type)) 
      (format t "Error in FILTERTYPE function. First argument must be a valid type name.~%")
    )
    ((filtertype_h type (car list)) (filtertype type (cdr list))) ; if the item in the list matches
                                                                  ; the type then dont include in list and recurse through rest of list
    (t (cons (car list) (filtertype type (cdr list))))            ; else include it in the list and recurse through rest of list
  )
)

;;TYPES FUNCTION
; One of the helper functions for the FILTERTYPE function. Checks if the type entered is valid.
(defun types (type)
  (cond
    ((eq type 'list) t)
    ((eq type 'string) t)
    ((eq type 'symbol) t)
    ((eq type 'number) t)
    ((eq type 't) t)
    ((eq type 'nil) t)
    (t nil)
  )
)

;;FILTERTYPE_H FUNCTION
; Another helper function for the FILTERTYPE function. Returns true if item matches the type, false otherwise.
(defun filtertype_h (type item)
  (cond
    ((eq type 'list) (listp item))
    ((eq type 'string) (stringp item))
    ((eq type 'symbol) (symbolp item))
    ((eq type 'number) (numberp item))
    ((eq type 't) (not (null item)))
    ((eq type 'nil) (null item))
    (t nil)
  )
)

