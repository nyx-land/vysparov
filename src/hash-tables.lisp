(in-package :vysparov)

(defun hash-print (table)
  "A utility function to print the values of a hash-table"
  (loop for k being the hash-key
          using (hash-value v) of table
        do (format t "~a: ~a~%" k v)))

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

(defmacro g# (table &body hashes)
  (labels ((rec (table &rest in)
             (if (cdr in)
                 (list 'gethash (car in)
                       (apply #'rec table (cdr in)))
                 (list 'gethash (car in) table))))
    `(progn
       ,(apply #'rec table hashes))))

(defmacro with-destructured-hash (table hashes &body body)
  `(let ,(loop for h in hashes
               collect `(,(car h)
                         (gethash ,(cadr h) ,table)))
     ,@body))
