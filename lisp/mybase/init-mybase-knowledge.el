
;; https://emacs-china.org/t/emacs-builtin-mode/11937/71?u=shadw3002
(use-package recentf
  :config
  (setq recentf-exclude '(
                          "/home/hermit/MyBase/Knowledge/*"
                          )))

(require 'seq)

(defun mybase-concat-nodes (nodes)
  (mapcar
   (lambda (node) (seq-reduce
                   (lambda (initial str)
                     (concat initial (concat ":" str)))
                   node
                   ""))
   nodes))

(defun node-to-str (node)
  (seq-reduce
    (lambda (initial str)
      (concat initial (concat ":" str)))
    node
    ""))

(defun mybase-knowledge--file-folder (file)
  (car (last (split-string file "/") 2)))

(defun counsel-mybase-node-as-key (node)
  (car node))

(defun counsel-mybase-search-get-table (nodes)
  (seq-reduce
   (lambda (table node)
     (add-to-list 'table (cons (counsel-mybase-node-as-key node) node)))
   nodes
   '()))

; (counsel-mybase-search-get-table (mybase-database-all-nodes))

(defun mybase-knowledge-new-node (str)
  (let* (hash (hash (secure-hash 'sha1 (format "%s%s" (current-time) str))))
    (cond ((mybase-database-has-node hash) (mybase-knowledge-new-node str))
          (t hash))))


(defun mybase-knowledge-rename-buffer ()
  (let ((file (buffer-file-name)))
    (when (string-prefix-p mybase-knowledge-dir file)
      (let* ((node (mybase-knowledge--file-folder file))
             (title (mybase-database-get-title node)))
        (rename-buffer (format "☆ %s" title))))))

;; (defun mybase-knowledge-rename-buffer ()
;;   (let ((file (buffer-file-name)))
;;     (when (string-prefix-p mybase-knowledge-dir file)
;;       (let ((title (mybase-knowledge--file-folder file)))
;;         (rename-buffer (format "☆ %s" title))))))

;; 搜索或创建 node
(defun counsel-mybase-search-nodes (&optional initial-input)
  "Call the \"locate\" shell command.
  INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
  (let* ((nodes (mybase-database-all-nodes))
         (node-pairs (counsel-mybase-search-get-table (mybase-database-all-nodes))))
    (ivy-read "Locate: " node-pairs
              :initial-input initial-input
              :action (lambda (input)   
                        (cond ((equal 'cons (type-of input))
                               ;; 存在，直接打开
                               (let* ((node (nth 2 input))
                                      (title (mybase-database-get-title node)))
                                 (when node
                                   (find-file (concat
                                               mybase-knowledge-dir
                                               "/"
                                               ;; title
                                               node
                                               "/main.org")))))
                              ((equal 'string (type-of input))
                               ;; 不存在，创建
                               (let ((node (mybase-knowledge-new-node input))
                                     (title input))
                                 (make-directory (concat mybase-knowledge-dir "/" node))
                                 (find-file (concat
                                             mybase-knowledge-dir
                                             "/"
                                             ;; title
                                             node
                                             "/main.org"))
                                 (insert (concat
                                          (format "#+NODE: %s\n" node)
                                          (format "#+TITLE: %s\n" title)
                                          "#+ALIAS: \n"
                                          "#+TAGS: \n"
                                          (format "#+CREATE_TIME: %s\n"
                                                  (format-time-string
                                                   "[%Y-%m-%d %a %H:%M:%S]"
                                                   (current-time)))
                                          "#+MODIFY_TIME: []\n"))
                                 (mybase-knowledge-save-update)
                                 ;; (mybase-knowledge-rename-buffer)
                                 ))
                              (t (message "unwilling error"))))
              :caller 'counsel-mybase-search-nodes)))

;; 搜索或创建 node
(defun counsel-mybase-link-node (&optional initial-input)
  "Call the \"locate\" shell command.
  INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
  (let* ((nodes (mybase-database-all-nodes))
         (node-pairs (counsel-mybase-search-get-table (mybase-database-all-nodes))))
    (ivy-read "Locate: " node-pairs
              :initial-input initial-input
              :action
              (lambda (input)   
                (cond ((equal 'cons (type-of input))
                       (let* ((node (nth 2 input))
                              (title (mybase-database-get-title node)))
                         (when node
                           (insert "[[../" node "/main.org][" title "]]")
                           )))
                      ((equal 'string (type-of input))
                       (message "unwilling error"))
                      (t (message "unwilling error"))))
              :caller 'counsel-mybase-link-node)))

;; 搜索或创建 node
(defun counsel-mybase-insert-link (&optional initial-input)
  "Call the \"locate\" shell command.
  INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
  (let* ((types '("Simple" "Single" "Multiple")))
    (ivy-read "Locate: " types
              :initial-input initial-input
              :action
              (lambda (type)
                (org-insert-heading)
                (org-set-property "LinkType" type)
                (cond ((equal type "Simple"))
                      ((equal type "Single")
                       (org-set-property "Description"  ""))
                      ((equal type "Multiple")
                       (org-set-property "Description"  ""))
                      (t (message "unwilling error"))
                      )
                )
              :caller 'counsel-mybase-insert-link)))


(use-package counsel
  :config
  
  (general-define-key
   :prefix "C-c"
   "s f" 'counsel-mybase-search-nodes
   "s l" 'counsel-mybase-insert-link
   "s i" 'counsel-mybase-link-node
   ))

(defun mybase-knowledge-get-prop (prop)
  (cdr (car (mybase-knowledge--extract-global-props (cons prop nil)))))

(defun mybase-knowledge-update-node (node hash meta title)
  (mybase-database-update-node node hash meta)
  (mybase-database-update-title node title))

(defun mybase-knowledge-save-update ()
  (let ((file (buffer-file-name)))
    (when (string-prefix-p mybase-knowledge-dir file)
      (goto-char 0)
      (re-search-forward "#\\+MODIFY_TIME: .*$" nil t)
      (replace-match
       (format "#+MODIFY_TIME: %s"
               (format-time-string
                "[%Y-%m-%d %a %H:%M:%S]"
                (current-time)))
       t)
      (let* ((node (mybase-knowledge-get-prop "NODE"))
             (hash (secure-hash 'sha1 (current-buffer)))
             (atime (mybase-knowledge-get-prop "CREATE_TIME"))
             (mtime (mybase-knowledge-get-prop "MODIFY_TIME"))
             (meta (list :atime atime :mtime mtime))
             (title (mybase-knowledge-get-prop "TITLE"))
             (folder (file-name-directory file))
             (current-folder-name (mybase-knowledge--file-folder file)))
        ;; (unless (equal current-folder-name title)
        ;; (rename-file folder (concat mybase-knowledge-dir "/" title))
        ;; (set-visited-file-name (concat
        ;;                         mybase-knowledge-dir
        ;;                         "/"
        ;;                         title
        ;;                         "/main.org")))
        (mybase-knowledge-rename-buffer)
        (mybase-knowledge-update-node node hash meta title)))))

;; 保存前更新
(add-hook 'before-save-hook 'mybase-knowledge-save-update)

;; 重命名 buffer
(use-package org
  :hook
  (org-mode . mybase-knowledge-rename-buffer))

(defun mybase-knowledge--extract-global-props (props)
  "Extract PROPS from the current org buffer.
The search terminates when the first property is encountered."
  (let ((buf (org-element-parse-buffer))
        res)
    (dolist (prop props)
      (let ((p (org-element-map buf 'keyword
                 (lambda (kw)
                   (when (string-collate-equalp (org-element-property :key kw) prop nil t)
                     (org-element-property :value kw)))
                 :first-match t)))
        (push (cons prop p) res)))
    res))

(use-package org-drill)

(provide 'init-mybase-knowledge)
