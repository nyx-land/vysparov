(in-package :vysparov)

(defun peek-nth-chars (num &optional (stream *standard-input*)
                             (eof-error t) eof-value)
  "A utility function to peek bytes like PEEK-CHAR."
  (let* ((chars (loop repeat num
                      for c = (read-char stream eof-error eof-value)
                      collect c))
         (npeek (car (last chars))))
    (loop for c in (reverse chars)
          unless (eq c :eof)
            do (unread-char c stream))
    npeek))
