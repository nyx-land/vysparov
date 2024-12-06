(defpackage #:vysparov
  (:nicknames :vy)
  (:use :cl)
  (:export
   :sub* :xyphenate
   :hash-print
   :dict :g# :with-destructured-hash
   :make-tr-node :tr-add
   :tr-lookup :peek-nth-chars
   :build-wild :search-wild
   :find-files))

(in-package :vysparov)
