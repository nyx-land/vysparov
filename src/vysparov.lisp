(defpackage :vysparov
  (:nicknames :vy)
  (:use :cl)
  (:export :split
           :dict
           :hyphenate
           :deepset))

(in-package :vysparov)

(defun split (delimiter str)
  "A bespoke string splitting function"
  (labels ((ss (s) (search delimiter str :start2 s)) ;; sorry
           (sx (z) (if (ss z) (ss z) (length str)))
           (sy (q) (search delimiter str :end2 q :from-end t)))
    (loop for x = (sx 0) then (sx (incf x))
          for y = 0 then (+ (length delimiter) (sy x))
          until (equalp x (length str))
          collect (subseq str y (sx x)) into pg
          finally (return (append pg (list (subseq str y (sx x))))))))

(defun dict (&rest vals)
  "Make a hash table in one go"
  (let ((out-hash (make-hash-table)))
    (loop for (x y) on vals
          by #'cddr
          do (setf (gethash x out-hash) y))
    out-hash))

(defun hyphenate (in-str)
  "Hyphenate a string"
  (loop for x across in-str
        if (equalp x #\Space)
          collect #\- into str
        else
          collect x into str
        finally (return (concatenate 'string str))))

(defmacro deepset (table &rest keys)
  "A horrendous macro for setting a nested hash table.
Badly in need of rewriting."
  `(progn
     (setf (gethash ,(car (last keys 2))
                    ,(reduce
                      (lambda (table key)
                        (if (gethash key (eval table))
                            `(gethash ,key ,table)
                            `(setf (gethash ,key ,table)
                                   (make-hash-table))))
                      (reverse (rest (rest (reverse keys))))
                      :initial-value table))
           ,(cadr (last keys 2)))))

(defun str->octets (str)
  (map 'vector #'char-code str))
