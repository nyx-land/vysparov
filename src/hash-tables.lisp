(in-package :vysparov)

(defun hash-print (table)
  "A utility function to print the values of a hash-table"
  (loop for k being the hash-key
          using (hash-value v) of table
        do (format t "~a: ~a~%" k v)))

(defun hashkeys (table)
  "Return a list of a hash table's keys"
  (loop for k being the hash-key of table
        collect k))

(defun hashvals (table)
  "Return a list of a hash table's values"
  (loop for k being the hash-key
          using (hash-value v) of table
        collect v))

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
