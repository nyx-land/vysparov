(defsystem "vysparov"
  :author "Nyx <n1x@riseup.net>"
  :description "Another utility library"
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "bitsmashing")
                 (:file "vysparov")
                 (:file "hash-tables")
                 (:file "trie")
                 (:file "pathnames")))))
