;; Knowledge

(defvar mybase-root-dit "/mnt/data/Base/")

;; Reactor

(defvar mybase-reactor-projects-dir  (concat mybase-root-dit "Reactor/Projects"))
(defvar mybase-reactor-journal-dir   (concat mybase-root-dit "Reactor/Journal"))
(defvar mybase-reactor-tasks-file    (concat mybase-root-dit "Reactor/Tasks/main.org"))
(defvar mybase-reactor-incubate-file (concat mybase-root-dit "Reactor/Incubate/main.org"))
(defvar mybase-reactor-inbox-file    (concat mybase-root-dit "Reactor/Inbox/main.org"))

(use-package org
  :config

  ;;
  (add-to-list 'org-agenda-files mybase-reactor-tasks-file)

  (mapc
    (lambda (x) (add-to-list 'org-agenda-files x))
    (directory-files-recursively mybase-reactor-projects-dir "\.org$")
  )

  ;; 
  (setq org-capture-templates '())
  (add-to-list
    'org-capture-templates
    '(
      "b" "Bullet"
      entry (file mybase-reactor-inbox-file)
      "* %?\n  :PROPERTIES:\n  :CREATED:%U\n  :END:\n  \n  %i\n  \n  From: %a"
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

  
)


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

(use-package hydra
  :config
  (defhydra hydra-mybase-reactor-refiler (org-mode-map "C-c k" :hint nil)
"
^Navigate^      ^Refile^         ^Move^          ^Update^        ^Go To^        ^Dired^
^^^^^^^^^^----------------------------------------------------------------------------------------
_k_: ↑ previous _m t_: tasks    _m P_: Projects  _T_: todo task  _g t_: tasks    _g P_: Projects
_j_: ↓ next     _m i_: incubate _m J_: Journal   _S_: schedule   _g i_: incubate _g J_: Journal
_c_: archive    _m r_: refile                  _D_: deadline   _g x_: inbox    
_d_: delete                                  _R_: rename        
"
    ("<up>" org-previous-visible-heading)
    ("<down>" org-next-visible-heading)

    ("k" org-previous-visible-heading)
    ("j" org-next-visible-heading)
    ("c" org-archive-subtree-as-completed)
    ("d" org-cut-subtree)

    ("m t" mybase-refile-to-tasks)
    ("m i" mybase-refile-to-incubate)
    ("m r" (mybase-reactor-refile-directly))
    
    ("m P" mybase-refile-to-projects)
    ("m J" mybase-refile-to-journal)

    ("T" org-todo)
    ("S" org-schedule)
    ("D" org-deadline)
    ("R" org-rename-header)

    ("g t" (find-file-other-window mybase-reactor-tasks-file))
    ("g i" (find-file-other-window mybase-reactor-incubate-file))
    ("g x" (find-file-other-window mybase-reactor-inbox-file))

    ("g P" (dired mybase-reactor-projects-dir))
    ("g J" (dired mybase-reactor-journal-dir))
    
    ("[\t]" (org-cycle))

    ("s" (org-save-all-org-buffers) "save")
    ("q" nil "quit")
  )
  
)


(provide 'init-mybase)

