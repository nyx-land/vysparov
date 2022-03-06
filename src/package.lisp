(defpackage :vysparov
  (:nicknames :vy)
  (:use :cl)
  (:export :split
           :dict
           :hashkeys
           :hashvals
           :xyphenate
           :sethash
           :str->octets
           :octets->str
           :cconv))

(in-package :vysparov)
