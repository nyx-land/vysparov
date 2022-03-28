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
        if (> v 0)
          collect (format nil "~a: ~a~%" (code-char k) v)))
