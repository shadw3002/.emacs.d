(require 'emacsql)
(require 'emacsql-sqlite3)

(defvar mybase-database--connection nil)

(defun mybase-database--get-file ()
  "Return the sqlite db file path"
  (concat mybase-root-dit "Cache/" "knowledge.db"))

(defun mybase-database--get-connection ()
  mybase-database--connection)

;;;; Schemata
(defconst mybase-database--table-schemata
  '((nodes
     [(node :unique :primary-key)
      (hash :not-null)
      (meta :not-null)])

    ;; (edges
    ;;  [(from :not-null)
    ;;   (to :not-null)
    ;;   (type :not-null)
    ;;   (properties :not-null)])

    ;; (tags
    ;;  [(node :unique :primary-key)
    ;;   (tags)])
    (links
     [(a b :not-null :primary-key)
      (type :not-null)
      (describe)])
    
    (linktypes
     [(type :unique :primary-key)
      (shortname :not-null)
      (describe :not-null)])
    
    (titles
     [(node :unique :primary-key)
      (title :not-null)])
    ))

(defun mybase-database--init (conn)
  "Initialize database DB."
  (emacsql conn
    (pcase-dolist (`(,table . ,schema) mybase-database--table-schemata)
      (emacsql conn [:create-table $i1 $S2] table schema))))

(defun mybase-database ()
  "Entrypoint to the Org-roam sqlite database."
  (unless (and (mybase-database--get-connection)
               (emacsql-live-p (mybase-database--get-connection)))
    (let* ((db-file (mybase-database--get-file))
           (need-init-db (not (file-exists-p db-file))))
      (make-directory (file-name-directory db-file) t)
      (let ((conn (emacsql-sqlite3 db-file)))
        (set-process-query-on-exit-flag (emacsql-process conn) nil)
        (setq mybase-database--connection conn)
        (when need-init-db
          (mybase-database--init conn)))))
  (mybase-database--get-connection))

(defun mybase-database--query (sql &rest args)
  "Run SQL query on Mybase database with ARGS.
SQL can be either the emacsql vector representation, or a string."
  (if  (stringp sql)
      (emacsql (mybase-database) (apply #'format sql args))
    (apply #'emacsql (mybase-database) sql args)))

(defun mybase-database-insert-node (node hash meta)
  "Insert HASH and META for a NODE into the mybase cache."
  (mybase-database--query
   [:insert :into nodes
            :values $v1]
            (list (vector node hash meta))))

(defun mybase-database-insert-title (node title)
  "Insert HASH and META for a NODE into the mybase cache."
  (mybase-database--query
   [:insert :into titles
            :values $v1]
            (list (vector node title))))

(defun mybase-database-insert-link (a b type describe)
  "Insert HASH and META for a NODE into the mybase cache."
  (mybase-database--query
   [:insert :into links
            :values $v1]
            (list (vector a b type describe))))

(defun mybase-database-insert-linktype (type shortname describe)
  "Insert HASH and META for a NODE into the mybase cache."
  (mybase-database--query
   [:insert :into linktypes
            :values $v1]
            (list (vector type shortname describe))))

(defun mybase-database-update-node (node hash meta)
  "Update the title of the current buffer into the cache."
       (mybase-database--query [:delete
                                :from nodes
                                :where (= node $s1)]
                               node)
       (mybase-database-insert-node node
                                    hash
                                    meta))

(defun mybase-database-update-title (node title)
  (mybase-database--query [:delete
                           :from titles
                           :where (= node $s1)]
                          node)
  (mybase-database-insert-title node
                                title))


(defun mybase-database-get-title (node)
  (car (car (mybase-database--query [:select [title]
                                     :from titles
                                     :where (= node $s1)] node))))

(defun mybase-database-all-nodes ()
  (mybase-database--query [:select [titles:title nodes:node]
                           :from nodes
                           :inner :join titles
                           :on (= nodes:node titles:node)]))

;; (mybase-database--all-nodes)

(defun mybase-database-has-node (node)
  (mybase-database--query [:select [node]
                           :from nodes
                           :where (= node $s1)]
                          node))


(provide 'init-mybase-database)
