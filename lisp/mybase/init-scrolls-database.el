(require 'emacsql)
(require 'emacsql-sqlite3)

(defvar scrolls-database--connection nil)

(defun scrolls-database--get-file ()
  "Return the sqlite db file path"
  (concat mybase-root-dit "Cache/Databases/" "AlgorithmProblems.db"))


(defun scrolls-database--get-connection ()
  scrolls-database--connection)

;;;; Schemata
(defconst scrolls-database--table-schemata
  '((problems
     [(source :not-null)
      (id :not-null)
      (title :not-null)
      (tags)
      (codes)])

    ;; (edges
    ;;  [(from :not-null)
    ;;   (to :not-null)
    ;;   (type :not-null)
    ;;   (properties :not-null)])

    ;; (tags
    ;;  [(node :unique :primary-key)
    ;;   (tags)])
    ))


(defun scrolls-database--init (conn)
  "Initialize database DB."
  (emacsql conn
    (pcase-dolist (`(,table . ,schema) scrolls-database--table-schemata)
      (emacsql conn [:create-table $i1 $S2] table schema))))


(defun scrolls-database ()
  "Entrypoint to the Org-roam sqlite database."
  (unless (and (scrolls-database--get-connection)
               (emacsql-live-p (scrolls-database--get-connection)))
    (let* ((db-file (scrolls-database--get-file))
           (need-init-db (not (file-exists-p db-file))))
      (make-directory (file-name-directory db-file) t)
      (let ((conn (emacsql-sqlite3 db-file)))
        (set-process-query-on-exit-flag (emacsql-process conn) nil)
        (setq scrolls-database--connection conn)
        (when need-init-db
          (scrolls-database--init conn)))))
  (scrolls-database--get-connection))


(defun scrolls-database--query (sql &rest args)
  "Run SQL query on Scrolls database with ARGS.
SQL can be either the emacsql vector representation, or a string."
  (if  (stringp sql)
      (emacsql (scrolls-database) (apply #'format sql args))
    (apply #'emacsql (scrolls-database) sql args)))


(defun scrolls-database-insert-problem (source id title tags codes)
  "Insert HASH and META for a NODE into the scrolls cache."
  (scrolls-database--query
   [:insert :into problems
            :values $v1]
            (list (vector source id title tags codes))))


(defun scrolls-database-update-problem (source id title tags codes)
  "Update the title of the current buffer into the cache."
       (scrolls-database--query [:delete
                                 :from problems
                                 :where (and (= source $s1) (= id $s2))]
                                 source id)
       (scrolls-database-insert-problem source
                                        id
                                        title
                                        tags
                                        codes))

(defun scrolls-database-all-nodes ()
  (sort
   (scrolls-database--query [:select * :from problems])
   (lambda (x y)
     (let ((xs (nth 0 x))
           (ys (nth 0 y))
           (xi (string-to-number (nth 1 x)))
           (yi (string-to-number (nth 1 y))))
       (or
        (string< xs ys)
        (and
         (string= xs ys)
         (< xi yi)))))))

(provide 'init-scrolls-database)
