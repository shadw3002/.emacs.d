;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; No need for ~ files when editing
(setq create-lockfiles nil)

(setq default-tab-width 4)

(setq-default indent-tabs-mode nil)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Four spaces is a tab
(setq tab-width 2)

;; 记录了上次打开文件时光标停留在第几行、第几列
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode)
  :config
  ;; keep track of saved places in ~/.emacs.d/places
  (setq save-place-file (concat user-emacs-directory "places"))
  )

;; 禁用自动保存
(setq auto-save-default nil)

;; 括号染色
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Emacs can automatically create backup files. This tells Emacs to
;; put all backups in ~/.emacs.d/backups. More info:
;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

;; 修改记录最近打开的文件的数量
(use-package recentf
  :config
  (setq recentf-max-menu-items 64)
  (setq recentf-max-saved-items 64))


(use-package smartparens
  :ensure t
  :init
  (bind-key "C-M-f" #'sp-forward-sexp smartparens-mode-map)
  (bind-key "C-M-b" #'sp-backward-sexp smartparens-mode-map)
  (bind-key "C-)" #'sp-forward-slurp-sexp smartparens-mode-map)
  (bind-key "C-(" #'sp-backward-slurp-sexp smartparens-mode-map)
  (bind-key "M-)" #'sp-forward-barf-sexp smartparens-mode-map)
  (bind-key "M-(" #'sp-backward-barf-sexp smartparens-mode-map)
  (bind-key "C-S-s" #'sp-splice-sexp)
  (bind-key "C-M-<backspace>" #'backward-kill-sexp)
  (bind-key "C-M-S-<SPC>" (lambda () (interactive) (mark-sexp -1)))

  :config
  (smartparens-global-mode t)

  (sp-pair "'" nil :actions :rem)
  (sp-pair "`" nil :actions :rem)
  (setq sp-highlight-pair-overlay nil))

(provide 'init-base)
