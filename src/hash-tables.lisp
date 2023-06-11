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

(defmacro with-keys ((&rest keys) table &body body)
  `(let ,(loop for k in keys
               with tn = (hash-normalize (eval table))
               unless (null (gethash k tn))
                 collect `(,k ,(gethash k tn)))
     ,@body))

(defun deepget (table &rest keys)
  "Get values from nested hash tables"
  (let* ((next (pop keys))
         (hash (gethash next table))
         (found (nth-value 1 (gethash next table))))
    (cond ((null found)
           (cons :not-found
                 (append (list table next) keys)))
          ((null keys)
           hash)
          ((hash-table-p hash)
           (apply #'deepget (push hash keys)))
          (t next))))

(defun deepset (table &rest keys)
  "Set values in nested hash tables"
  (let ((path (apply #'deepget (push table keys))))
    (when (eq :not-found (car path))
      (pop path)
      (labels ((recset (tab k)
                 (let ((key (pop k))
                       (val (make-hash-table)))
                   (if (cdr k)
                       (progn 
                         (setf (gethash key tab)
                               val)
                         (recset val k))
                       (setf (gethash key tab)
                             (car k))))))
        (recset (car path) (cdr path))))))
