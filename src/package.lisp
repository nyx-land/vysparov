(defpackage #:vysparov
  (:nicknames :vy)
  (:use :cl)
  (:export
   :sub* :xyphenate
   :hash-print
   :dict :with-keys
   :deepget :deepset
   :make-tr-node :tr-add
   :tr-lookup :peek-nth-chars))

(in-package :vysparov)
