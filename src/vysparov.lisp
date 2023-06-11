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

