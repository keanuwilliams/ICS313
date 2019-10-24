;;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-
;;;; Name: Keanu Williams      Date: October 4th, 2019
;;;; Course: ICS313            Assignment: 3
;;;; File: kwill303AITERATIVE.lisp

(defvar +ID+ "Keanu Williams")

;;FIBONACCI FUNCTION (ITERATIVE)
; Using index x, iteratively finds the number associated with the index in the fibonnaci sequence. 
(defun fibonacci_i (x)
  (cond
    ((not (integerp x))
      (format t "Parameter must be a number.~%") ())
    (t
      (do ((n 0 (1+ n))
        (current 0 next)
        (next 1 (+ current next)))
        ((eq x n) current))
    )
  )
)

;;REMOVE NUMBER FUNCTION (ITERATIVE)
; Removes all the numbers from the list and returns the list.
; It doesnt work if there are sublists in the list.
(defun remove-numbers_i (x)
  (cond
    ((not (listp x))
      (format t "Parameter must be a list.~%") ())
    ((null x)
      (format t "List is empty.~%") ())
    (t
      (remove-if #'numberp x)
    )
  )
)
