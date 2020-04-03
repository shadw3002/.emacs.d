;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check version

(when (version< emacs-version "26.3")
  (error "This requires Emacs 26.3 and above!"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add Load Path

(defun update-load-path (&rest _)
  "Update `load-path'."
  (push (expand-file-name "site-lisp" user-emacs-directory) load-path)
  (push (expand-file-name "lisp" user-emacs-directory) load-path))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'."
  (let ((default-directory
          (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)

(update-load-path)

;; (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; (add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory) load-path)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Init


(require 'init-packages)

(require 'init-base)

(require 'init-ui)

(require 'init-shortkey)

(require 'init-shortkey-hint)

(require 'init-snippets)

;; (require 'init-hydra)

(require 'init-evil)

(require 'init-counsel)

(require 'init-editing)

(require 'init-company)

(require 'init-check)

(require 'init-dired)

(require 'init-vterm)

(require 'init-org)

(require 'init-treemacs)

(require 'init-eaf)

(require 'init-mybase)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; others

(require 'recentf)
(recentf-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (use-package which-key))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-modeline-buffer-modified ((t (:inherit bold))))
 '(org-ellipsis ((t (:foreground nil))))
 '(org-level-1 ((t (:foreground "RosyBrown")))))
