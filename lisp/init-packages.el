(require 'cl)

(require 'package)

(setq package-archives '(
    ("gnu"   . "http://elpa.emacs-china.org/gnu/")
    ("melpa" . "http://elpa.emacs-china.org/melpa/")
    ("org"   . "https://orgmode.org/elpa/")
))

(package-initialize)

;;add whatever packages you want here
(defvar gensokyo/packages '(
  yasnippet
  ivy-posframe
  hydra
  htmlize
  flycheck
  company
  use-package
  all-the-icons
  which-key
  evil
  doom-themes
  doom-modeline
  counsel
  hydra
  rainbow-delimiters
  pretty-hydra
  org-bullets
  general
  treemacs
  treemacs-evil
  treemacs-icons-dired
  async
  racer
  flycheck-rust
  rust-mode
  vterm
  )  "Default packages")

(defun gensokyo/packages-installed-p ()
  (loop for pkg in gensokyo/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (gensokyo/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg gensokyo/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

(setq package-selected-packages gensokyo/packages)

(eval-when-compile
  (require 'use-package))

;; report about loading and configuration details.
(setq use-package-verbose t)

(provide 'init-packages)
