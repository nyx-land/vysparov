(defpackage #:vysparov
  (:nicknames :vy)
  (:use :cl)
  (:export
   :split :hash-print
   :dict :with-keys
   :deepget :deepset
   :xyphenate :str->octets
   :octets->str
   :make-tr-node :tr-add
   :tr-lookup :peek-nth-chars))

(in-package :vysparov)
