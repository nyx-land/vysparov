(in-package #:vysparov)

(defun xyphenate (str d c)
  "xyphenate a string (hyphenation with an arbitrary
deliminter and hyphenating character)."
  (loop for x across str
        if (equalp x d)
          collect c into out-str
        else
          collect x into out-str
        finally (return (concatenate 'string out-str))))

(defun sub* (input new &rest chars)
  "Substitute various characters at once"
  (labels ((subfn (in chars)
             (if (null chars)
                 in
                 (let ((old (pop chars)))
                   (subfn (substitute new old in) chars)))))
    (subfn input chars)))

(defun sym->key (sym)
  (intern (symbol-name sym) :keyword))

(defun sym<-key (key)
  (read-from-string (symbol-name key)))
