;;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-
;;;; Name: Keanu Williams      Date: October 4th, 2019
;;;; Course: ICS313            Assignment: 3
;;;; File: kwill303A.lisp

(defvar +ID+ "Keanu Williams")

;;FIBONACCI FUNCTION
; Using index x, recursively finds the number associated with the index in the fibonnaci sequence. 
(defun fibonacci (x)
  (cond
    ((or(not (integerp x)) (< x 0))
      (format t "Parameter must be a positive number.~%")
    () ) ; return nil
    ((eq x 0) 0) ; 1st base case
    ((eq x 1) 1) ; 2nd base case
    (t ; recursive case
      (+ (fibonacci(1- x)) (fibonacci(- x 2))) ; x = (x-1) + (x-2)
    )
  )
)

;;GREATEST COMMON DIVISOR FUNCTION
; Find the largest integer that is a divisor of all the parameters.
(defun gcd (x y &optional z)
  (cond
    ((null z) ; if no z is included
      (cond
        ((and (integerp x) (integerp y))
          (cond
            ((eq y 0) x) ; if y = 0 return x
            (t (gcd y (mod x y))) ; else find gcd
          )
        )
        (t ; else print error message
          (format t "All parameters must be integers.~%")
        )
      )
    )
    (t ; else if z is included
      (cond
        ((and (integerp x) (integerp y) (integerp z))
          (cond
            ((eq z 0) (gcd x y)) ; if z = 0 return the gcd of x and y
            (t (gcd z (mod (gcd x y) z))) ; else find gcd
          )
        )
        (t ; else print error message
          (format t "All parameters must be integers.~%")
        )
      )
    )
  )
)

;;LEAST COMMON MULTIPLE FUNCTION
; Finds the smallest number that the parameters are factors of.
(defun lcm (x y &optional z)
  (cond
    ((null z) ; if no z is included
      (cond
        ((and (integerp x) (integerp y)) ; if both parameters are integers
          (/ (abs (* x y)) (gcd x y)) ; find least common multiple
        )
        (t ; else print error message
          (format t "All parameters must be integers.~%")
        )
      )
    )
    (t ; else if z is included
      (cond 
        ((and (integerp x) (integerp y) (integerp z)) 
          (lcm (/ (abs (* x y)) (gcd x y)) z) ; use the lcm of the first two nums 
                                              ; to find lcm of all three
        )
        (t ; else print error message
          (format t "All parameters must be integers.~%")
        )
      )
    
    )
  )
)

;;REMOVE NUMBERS FUNCTION
; Takes a list of parameters and returns the parameter list without any numbers.
(defun remove-numbers (x)
  (cond
    ((not (listp x)) ; if x is not a list
      (format t "Parameter must be a list.~%") () ; print message and return nil
    )
    ((null x) ; if list is empty
      () ; return nil
    )
    ((listp (car x)) ; if the first element of list is another list
      (cons (remove-numbers (car x)) (remove-numbers (cdr x))) ; apply function to the list
                                                               ; and add to outer list
    )
    ((numberp (car x)) ; if first element of list is a number
      (remove-numbers (cdr x)) ; ignore it and keep looking through list
    )
    (t
      (cons (car x) (remove-numbers (cdr x))) ; add to list and keep looking through list
    )
  )
)

