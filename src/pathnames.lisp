(in-package :vysparov)

(defun build-wild (path exts &key (recursive t))
  "Build a list of wildcard pathnames."
  (let ((name (namestring path))
        (wildcard (if recursive "**/*"
                      "*")))
    (map 'list
         (lambda (x)
           (format nil "~a~a.~a" name wildcard x))
         exts)))

(defun search-wild (wilds)
  "Search a list of wildcard pathnames and return a
list of the results."
  (remove nil (map 'list #'directory wilds)))
