(in-package :vysparov)

(defun split (delimiter str)
  "A bespoke string splitting function. Horrendous, needs
to be rewritten."
  (labels ((ss (s) (search delimiter str :start2 s)) ;; sorry
           (sx (z) (if (ss z) (ss z) (length str)))
           (sy (q) (search delimiter str :end2 q :from-end t)))
    (loop for x = (sx 0) then (sx (incf x))
          for y = 0 then (+ (length delimiter) (sy x))
          until (equalp x (length str))
          collect (subseq str y (sx x)) into pg
          finally (return (append pg (list (subseq str y (sx x))))))))

(defun dict (&rest vals)
  "Make a hash table in one go. :TEST is a reserved value that
needs to be passed first to change the hash-table test, e.g. to
use strings as keys."
  (let ((out-hash (if (equalp (first vals) :test)
                      (make-hash-table :test (second vals))
                      (make-hash-table))))
        (loop for (x y) on vals
              by #'cddr
              unless (equalp x :test)
              do (setf (gethash x out-hash) y))
        out-hash))

(defun hashkeys (table)
  "Return a list of a hash table's keys"
  (loop for k being the hash-key of table
        collect k))

(defun hashvals (table)
  "Return a list of a hash table's values"
  (loop for k being the hash-key
          using (hash-value v) of table
        collect v))

(defun xyphenate (str d c)
  "xyphenate a string (hyphenation with an arbitrary
deliminter and hyphenating character)."
  (loop for x across str
        if (equalp x d)
          collect c into out-str
        else
          collect x into out-str
        finally (return (concatenate 'string out-str))))

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

