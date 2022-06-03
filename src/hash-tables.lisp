(in-package :vysparov)

(defun copy-hash-table (hash-table)
  "A utility function to copy a hash table."
  (let ((table (make-hash-table
                :test (hash-table-test hash-table)
                :rehash-size (hash-table-rehash-size hash-table)
                :rehash-threshold (hash-table-rehash-threshold hash-table)
                :size (hash-table-size hash-table))))
    (loop for k being each hash-key of hash-table
            using (hash-value v)
          do (setf (gethash k table) v)
          finally (return table))))

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

(defgeneric hash-normalize (input)
  (:documentation "Normalize a hash-table for selecting it from WITH-KEYS. By default
it just returns the value, if it doesn't need to be normalized.")
  (:method (input)
    input))

(defmethod hash-normalize ((input string))
  (read-from-string (xyphenate input #\space #\-)))

(defmethod hash-normalize ((input hash-table))
  (let ((tn (make-hash-table)))
    (loop for k being the hash-key of input
          for kn = (hash-normalize k)
          do (setf (gethash kn tn)
                   (gethash k input))
          finally (return tn))))

(defmacro with-keys ((&rest keys) table &body body)
  `(let ,(loop for k in keys
               with tn = (hash-normalize (eval table))
               unless (null (gethash k tn))
                 collect `(,k ,(gethash k tn)))
     ,@body))
