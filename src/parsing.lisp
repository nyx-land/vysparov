;; A small set of string parsing functions
;; Not suitable for anything really heavy like a compiler, but
;; hopefully useful for extracting syntax from a string.

(in-package :vysparov)

(defun scanner (str tok-list)
  "An extremely simple string scanner, if it can even
be called that. Returns the coordinates of the tokens."
  (loop for x across str
        for y = 0 then (incf y)
        when (member x tok-list)
          collect y))

(defun lexer (str tok-list fn)
  "Generate a scan of a string, then do something
at each coordinate."
  (let ((coords (scanner str tok-list)))
    (loop for x in coords
          do (funcall fn str x))))

(defmacro parser (name str pos &rest conds)
  (labels ((pt () (car txt pos))
           (et (x) (equalp x (pt))))
    `(defun ,(read-from-string
              (format nil "~-parser" name)) (str pos)
       (cond ))))

(defun org-parse (txt pos)
  (labels ((pt () (char txt pos))
           (et (x) (equalp x (pt))))
    (cond ((et #\[) (format t "url-start~%"))
          ((et #\]) (format t "url-end~%")))))
