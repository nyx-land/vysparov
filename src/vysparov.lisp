(defpackage :vysparov
  (:nicknames :vy)
  (:use :cl)
  (:export :split
           :dict
           :xyphenate
           :sethash
           :str->octets
           :octets->str
           :cconv))

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

(defun xyphenate (str c)
  "xyphenate a string (hyphenation with an arbitrary
character)."
  (loop for x across str
        if (equalp x #\Space)
          collect c into str
        else
          collect x into str
        finally (return (concatenate 'string str))))

(defun sethash (table &rest keys)
  "A more reasonable way of setting nested hashtables."
  (let ((end (car (last keys)))
        (vals (butlast keys)))
    (loop for x in vals
          with y = table
          if (gethash x y)
            do (setf y (gethash x y))
          else
            do (progn
                 (setf (gethash x y) (make-hash-table))
                 (setf y (gethash x y)))
          finally (setf (gethash x y) end))))

(defun cconv (ctype vec)
  "Convert from one collection to another"
  (map ctype #'identity vec))

(defun str->octets (str)
  "A simple little string to octet function"
  (map '(vector (unsigned-byte 8)) #'char-code str))

(defun octets->str (vec)
  "A simple little octet to string function"
  (map 'string #'code-char vec))
