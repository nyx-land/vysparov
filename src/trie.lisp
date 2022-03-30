(defstruct tr-node
  val
  (children (list)))

(defun tr-lookup (key root)
  (if (= (length key) 0)
      (tr-node-val root)
      (let ((slice (aref key 0)))
        (if (assoc slice (tr-node-children root))
            (tr-lookup (subseq key 1)
                       (cdr (assoc slice (tr-node-children root))))
            :not-found))))

(defun tr-add (key val root)
  (if (equalp key "")
      (if (not (tr-node-val root))
          (setf (tr-node-val root) val)
          (cerror "There was already a value at: ~a"
                  (tr-node-val root)))
      (let ((slice (aref key 0)))
        (if (not (assoc slice (tr-node-children root)))
            (progn
              (let ((child (make-tr-node)))
                (push (cons slice child) (tr-node-children root))
                (tr-add (subseq key 1) val child)))
            (tr-add (subseq key 1) val
                    (cdr (assoc slice (tr-node-children root))))))))
