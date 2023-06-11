(defun build-wild (path exts &key (recursive t))
  "Build a list of wildcard pathnames."
  (map 'list
       (lambda (x)
         (merge-pathnames
          (make-pathname
           :directory `(:relative
                        ,(if recursive :wild-inferiors :wild))
           :name :wild
           :type (if x x :wild))
          path))
       exts))

(defun search-wild (wilds)
  "Search a list of wildcard pathnames and return a
list of the results."
  (remove nil (map 'list #'directory wilds)))

(defun find-files (path &rest exts)
  (search-wild
   (build-wild path exts)))
