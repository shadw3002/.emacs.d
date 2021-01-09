;; Knowledge

(defvar mybase-root-dit "/home/hermit/MyBase/")

;; Reactor

(defvar mybase-reactor-projects-dir  (concat mybase-root-dit "Reactor/Projects"))
(defvar mybase-reactor-journal-dir   (concat mybase-root-dit "Reactor/Journal"))
(defvar mybase-reactor-tasks-file    (concat mybase-root-dit "Reactor/Tasks/main.org"))
(defvar mybase-reactor-incubate-file (concat mybase-root-dit "Reactor/Incubate/main.org"))

;; three: phone 
(defvar mybase-reactor-inbox-file    (concat mybase-root-dit "Reactor/Inbox/main.org"))
(defvar mybase-reactor-phone-inbox-file    "/mnt/webdav/Inbox/main.org")

(defvar mybase-knowledge-dir (concat mybase-root-dit "Knowledge"))

(require 'org)
(setq org-agenda-files '())
;;
(add-to-list 'org-agenda-files mybase-reactor-tasks-file)

(mapcar
  (lambda (x) (add-to-list 'org-agenda-files x))
  (directory-files-recursively mybase-reactor-projects-dir "\.org$"))

;; 
(setq org-capture-templates '())
(add-to-list
  'org-capture-templates
  '(
    "b" "Bullet"
    entry (file mybase-reactor-inbox-file)
    "* TODO %?\n:PROPERTIES:\n:CREATED:%U\n:END:\n\n%i\n"
    :empty-lines 1
  )
)

(setq org-todo-keywords
    (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
            (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))


(setq org-todo-keyword-faces
    (quote (("TODO" :foreground "red" :weight bold)
            ("NEXT" :foreground "blue" :weight bold)
            ("DONE" :foreground "forest green" :weight bold)
            ("WAITING" :foreground "orange" :weight bold)
            ("HOLD" :foreground "magenta" :weight bold)
            ("CANCELLED" :foreground "forest green" :weight bold)
            ("MEETING" :foreground "forest green" :weight bold)
            ("PHONE" :foreground "forest green" :weight bold))))

;; Capture in org-mode
(setq org-default-notes-file (concat org-directory "/notes.org"))
(global-set-key (kbd "\C-cc") 'org-capture)

(defun org-subtree-region ()
  "Return a list of the start and end of a subtree."
  (save-excursion
    (list (progn (org-back-to-heading) (point))
          (progn (org-end-of-subtree)  (point)))))


(defvar mybase-reactor-refile-directly-show-after nil
  "When refiling directly (using the `mybase-reactor--refile-directly'
function), show the destination buffer afterwards if this is set
to `t', otherwise, just do everything in the background.")

(defun mybase-reactor-refile-directly (file-dest)
"Move the current subtree to the end of FILE-DEST.
If SHOW-AFTER is non-nil, show the destination window,
otherwise, this destination buffer is not shown."
  (interactive "fDestination: ")

  (defun dump-it (file contents)
    (find-file-other-window file-dest)
    (goto-char (point-max))
    (insert "\n" contents))

  (save-excursion
    (let* ((region (org-subtree-region))
           (contents (buffer-substring (first region) (second region))))
      (apply 'kill-region region)
      (if mybase-reactor-refile-directly-show-after
          (save-current-buffer (dump-it file-dest contents))
        (save-window-excursion (dump-it file-dest contents))))))

(defun mybase-refile-to-tasks ()
  "Refile (move) the current Org subtree to `mybase-reactor-tasks-file'."
  (interactive)
  (mybase-reactor-refile-directly mybase-reactor-tasks-file))

(defun mybase-refile-to-incubate ()
  "Refile (move) the current Org subtree to `mybase-reactor-incubate-file'."
  (interactive)
  (mybase-reactor-refile-directly mybase-reactor-incubate-file))

(defun mybase-refile-to-projects ()
  "Refile (move) the current Org subtree to `mybase-reactor-projects-file'."
  (interactive)
  (let ((title (org-entry-get nil "ITEM")))
    (make-directory (concat mybase-reactor-projects-dir "/" title))
    (mybase-reactor-refile-directly (concat mybase-reactor-projects-dir "/" title "/main.org"))))

(use-package hydra
  :config
  (defhydra hydra-mybase-reactor-refiler (global-map "C-c k" :hint nil)
"
^Navigate^      ^Refile^          ^Update^        ^Go To^         ^Dired^
^^^^^^^^^^----------------------------------------------------------------------------------------
_k_: ↑ previous _m t_: tasks      _T_: todo task  _g t_: tasks    _g p_: Projects
_j_: ↓ next     _m i_: incubate   _S_: schedule   _g i_: incubate _g j_: Journal
_c_: archive    _m p_: Projects   _D_: deadline   _g x_: inbox    
_d_: delete     _m j_: Journal    _R_: rename     _g f_: phone   
"
    ("<up>" org-previous-visible-heading)
    ("<down>" org-next-visible-heading)

    ("k" org-previous-visible-heading)
    ("j" org-next-visible-heading)
    ("c" org-archive-subtree-as-completed)
    ("d" org-cut-subtree)

    ("m t" mybase-refile-to-tasks)
    ("m i" mybase-refile-to-incubate)
    ;; ("m r" (mybase-reactor-refile-directly))
    
    ("m p" mybase-refile-to-projects)
    ("m j" mybase-refile-to-journal)

    ("T" org-todo)
    ("S" org-schedule)
    ("D" org-deadline)
    ("R" org-rename-header)

    ("g t" (find-file-other-window mybase-reactor-tasks-file))
    ("g i" (find-file-other-window mybase-reactor-incubate-file))
    ("g x" (find-file-other-window mybase-reactor-inbox-file))
    ("g f" (find-file-other-window mybase-reactor-phone-inbox-file))

    ("g p" (dired mybase-reactor-projects-dir))
    ("g j" (dired mybase-reactor-journal-dir))
    
    ("[\t]" (org-cycle))

    ("s" (org-save-all-org-buffers) "save")
    ("q" nil "quit")
  )
  
)

;; Knowledge

;; 搜索支持
(use-package counsel
  :config
  (defun counsel-mybase-search-function (str)
    (or
     (ivy-more-chars)
     (progn
       (counsel--async-command
        ;; "rg -g main.org --files /mnt/data/Base | rg --color never %s"
        (format "find /home/hermit/MyBase/Buffer -type d ! -name 'ltximg' ! -name 'img' ! -name 'images' -iname '*%s*'"
                (counsel--elisp-to-pcre
                 (ivy--regex str))))
       '("" "working..."))))

  (defun counsel-mybase-search-transformer (str)
    "Only show dir name."
    (car (last (split-string str "/")))
   )

  
  ;;;###autoload
  (defun counsel-mybase-search (&optional initial-input)
    "Call the \"locate\" shell command.
  INITIAL-INPUT can be given as the initial minibuffer input."
    (interactive)
    (ivy-read "Locate: " #'counsel-mybase-search-function
              :initial-input initial-input
              :dynamic-collection t
              ;; :history 'counsel-locate-history
              :action (lambda (file)
                        (with-ivy-window
                          (when file
                            (find-file (concat
                                        mybase-root-dit "Buffer/" (counsel-mybase-search-transformer file) "/main.org")))))
              :unwind #'counsel-delete-process
              :caller 'counsel-mybase-search))

  (ivy-configure 'counsel-mybase-search
    :display-transformer-fn #'counsel-mybase-search-transformer
    :more-chars 1)

  (general-define-key
   :prefix "C-c"
   "m" 'counsel-mybase-search
   )
)

(provide 'init-mybase)

