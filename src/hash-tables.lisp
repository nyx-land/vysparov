(in-package :vysparov)

(defun hash-print (table)
  "A utility function to print the values of a hash-table"
  (loop for k being the hash-key
          using (hash-value v) of table
        do (format t "~a: ~a~%" k v)))

(defmacro dict ((&key (test #'eql)) &body entries)
  `(let ((table (make-hash-table :test ,test)))
     (loop for (k v) on (list ,@entries)
             by #'cddr
           do (setf (gethash k table) v))
     table))

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
