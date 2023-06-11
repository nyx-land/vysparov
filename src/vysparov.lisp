(in-package #:vysparov)

(defun split (delimiter str)
  "A bespoke string splitting function. Horrendous, needs
to be rewritten."
  (loop for i = 0 then (incf j)
        as j = (position delimiter str :start i)
        collect (subseq str i j)
        while j))

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

