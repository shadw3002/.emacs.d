(require 'init-scrolls-database)

;; num name difficulty tag solutions

(defun scrolls-search-buffer()
  (get-buffer-create "*scrolls-search*"))

(setq scrolls-entries nil)

(setq scrolls-root "/home/hermit/MyBase/Databases/AlgorithmProblems")

(defun scrolls-query-to-alist (query-result)
  (if query-result
      `((:source , (nth 0 query-result))
        (:id     , (nth 1 query-result))
        (:title  , (nth 2 query-result))
        (:tags   , (nth 3 query-result))
        (:codes  , (nth 4 query-result)))))

(defun scrolls-getattr (alist key)
  (cadr (assoc key (car alist))))

(defun scrolls-format-item (alist)
  (let ((source (scrolls-getattr (list alist) :source))
        (id (scrolls-getattr (list alist) :id))
        (title (scrolls-getattr (list alist) :title))
        (tags (scrolls-getattr (list alist) :tags))
        (codes (scrolls-getattr (list alist) :codes)))
    ))


(scrolls-query-to-alist (nth 0 (scrolls-database-all-nodes)))



(defun scrolls-candidates ()
  (mapcar
   (lambda (query)
     (let* ((alist (scrolls-query-to-alist query))
            (source (scrolls-getattr (list alist) :source))
            (id (scrolls-getattr (list alist) :id))
            (title (scrolls-getattr (list alist) :title))
            (tags (string-join
                   (car (read-from-string (scrolls-getattr (list alist) :tags)))
                   ", "))
            (codes (scrolls-getattr (list alist) :codes))
            (path (concat scrolls-root "/" source "/" id " - " title "/main.org")))
       (format
        "| %s | %s | [[%s][%s]] | %s | %s |"
        source id path title tags codes)))
   (scrolls-database-all-nodes)))

(defun scrolls-table-view ()
  (interactive)
  (let ((cand (if scrolls-entries
                  scrolls-entries
                (progn
                  (setq scrolls-entries (scrolls-candidates))
                  (setq scrolls-full-entries scrolls-entries)))))
    (cond ((not cand)
           (message "INVALID ITEMS"))
          (t
           (when (get-buffer (scrolls-search-buffer))
             (kill-buffer (scrolls-search-buffer)))
           (switch-to-buffer (scrolls-search-buffer))
           (goto-char (point-min))

           (insert "* Problems\n")
           (unless (equal cand '(""))
             (insert "| Source | ID | Title | Tags | Codes |\n")
             (insert "|--------+----+-------+------+-------|\n")
             (dolist (item cand)
               (let (beg end)
                 (setq beg (point))
                 (insert item)
                 ;; (calibredb-detail-view-insert-image item)
                 (setq end (point))
                 ;; (put-text-property beg end 'calibredb-entry item)
                 (insert "\n")))
             (goto-char (point-min)))

           
           ;; (calibredb-ref-default-bibliography)
           (unless (eq major-mode 'org-mode)
             (org-mode)
             (setq truncate-lines t
                   buffer-read-only t
                   ;; header-line-format '(:eval (funcall scrolls-header-function))
                   )
             (buffer-disable-undo)
             (set (make-local-variable 'hl-line-face) 'calibredb-search-header-highlight-face)
             ;; (hl-line-mode)
             )))))

(define-derived-mode scrolls-mode fundamental-mode "scrolls"
  "Major mode for listing scrolls entries.
\\{scrolls-mode-map}"
  (setq truncate-lines t
        buffer-read-only t
        ;; header-line-format '(:eval (funcall scrolls-header-function))
        )
  (buffer-disable-undo)
  (set (make-local-variable 'hl-line-face) 'calibredb-search-header-highlight-face)
  (hl-line-mode)
  ;; (if (boundp 'ivy-sort-matches-functions-alist)
  ;;     (add-to-list 'ivy-sort-matches-functions-alist '(calibredb-add . ivy--sort-files-by-date)))
  ;; (if (boundp 'ivy-alt-done-functions-alist)
  ;;     (add-to-list 'ivy-alt-done-functions-alist '(calibredb-add . ivy--directory-done)))
  ;; (add-hook 'minibuffer-setup-hook 'calibredb-search--minibuffer-setup)
  )

(defun scrolls-save-update ()
  (let ((file (buffer-file-name)))
    (when (string-prefix-p scrolls-root file)
      (goto-char 0)
      (re-search-forward "#\\+MODIFY_TIME: .*$" nil t)
      (replace-match
       (format "#+MODIFY_TIME: %s"
               (format-time-string
                "[%Y-%m-%d %a %H:%M:%S]"
                (current-time)))
       t)
      (let* ((is (last (split-string file "/") 3))
             (source (nth 0 is))
             (js (split-string (nth 1 is) " - "))
             (id (nth 0 js))
             (title (nth 1 js))
             (tags (prin1-to-string
                    (split-string
                     (mybase-knowledge-get-prop "TAGS") ", ")))
             (codes ""))
        (scrolls-database-update-problem source id title tags codes))

      
      )

    ))

(defun matches-in-buffer (regexp &optional buffer)
  "return a list of matches of REGEXP in BUFFER or the current buffer if not given."
  (let ((matches))
    (save-match-data
      (save-excursion
        (with-current-buffer (or buffer (current-buffer))
          (save-restriction
            (widen)
            (goto-char 1)
            (while (search-forward-regexp regexp nil t 1)
              (push (match-string 0) matches)))))
      matches)))

(defun scrolls-insert-item (&optional initial-input)
  "Call the \"locate\" shell command.
  INITIAL-INPUT can be given as the initial minibuffer input."
  (interactive)
  (let* ((sources '(("LeetCode" "1") ("剑指 Offer" "2"))))
    (ivy-read "Sources: " sources
              :initial-input initial-input
              :action
              (lambda (input)
                (cond ((equal 'cons (type-of input))
                       (let* ((source (nth 0 input))
                              (number (call-interactively
                                       (lambda (x) (interactive "sNumber: ") x)))
                              (title (call-interactively
                                      (lambda (x) (interactive "sTitle: ") x)))
                              (dir (concat mybase-root-dit
                                            "Databases/"
                                            "AlgorithmProblems/"
                                            source "/"
                                            number " - " title "/"
                                            ))
                              (path (concat dir "main.org")))
                         (make-directory dir t)
                         (find-file path)
                         (insert (concat
                                  (format "#+NUMBER: %s\n" number)
                                  (format "#+TITLE: %s\n" title)
                                  (format "#+DIFFICULTY: \n")
                                  (format "#+TAGS: \n")
                                  (format "#+CREATE_TIME: %s\n"
                                          (format-time-string
                                           "[%Y-%m-%d %a %H:%M:%S]"
                                           (current-time)))
                                  "#+MODIFY_TIME: []\n\n"
                                  "* Reference\n\n"
                                  "* Description\n\n"
                                  "* Solution\n\n"
                                  "* Code\n\n"))
                         (scrolls-save-update)
                         ))
                      ((equal 'string (type-of input))
                       )
                      (t (message "unwilling error"))))
              :caller 'scrolls-insert-item))
  )

(add-hook 'before-save-hook 'scrolls-save-update)

(defvar scrolls-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "i" #'scrolls-insert-item())
    map)
  "Keymap for `scrolls-mode'.")


(defun scrolls-problems-list()
  (let* ((problems (scrolls-database-all-nodes))
         (display-list))
    (dolist (problem problems display-list)
      (setq display-list
            (cons (list (scrolls-format-problem problem) problem) display-list)))
    ))

(use-package counsel
  :config
  
  (general-define-key
   :prefix "C-c"
   "d a" 'scrolls-table-view
   ))

  
(defun scrolls-delete-item())

(defun scrolls-open-item())

(provide 'init-scrolls)
