
(setq calibredb-root-dir "/home/hermit/MyBase/Databases/Materials")

(use-package calibredb
	:ensure t
  :config
  (setq sql-sqlite-program "/usr/bin/sqlite3")
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  (setq calibredb-program "/usr/bin/calibredb")
  (setq calibredb-library-alist '(("/home/hermit/MyBase/Databases/Materials")
                                  ))
  )

(use-package org-ref
  :ensure t
  :config
(setq calibredb-ref-default-bibliography (concat (file-name-as-directory calibredb-root-dir) "catalog.bib"))
(add-to-list 'org-ref-default-bibliography calibredb-ref-default-bibliography)
(setq org-ref-get-pdf-filename-function 'org-ref-get-mendeley-filename)
(setq calibredb-format-icons t)

  (general-define-key
   :prefix "C-c"
   "d m" 'calibredb
  )
  )

;; type mixed
;; template: {calibreid}.《{title}》.{authors}

(provide 'init-calibredb)
