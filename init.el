;;; init.el --- Emacs Configuration.


;;; Commentary:


;;; Code:


;; Add Load Path
;;
;; ./lisp/ : .el for configs
;; ./site-lisp : .el, custom package

(defun update-load-path (&rest _)
  "Update `load-path'."
  (dolist (dir '("site-lisp" "lisp"))
    (push (expand-file-name dir user-emacs-directory) load-path)))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'."
  (let ((default-directory
          (expand-file-name "lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)

(update-load-path)

;; pre

(require 'init-optimize)

(require 'init-package)

(let ((gc-cons-threshold most-positive-fixnum)
      ;; 加载的时候临时增大`gc-cons-threshold'以加速启动速度。
      ;; 清空避免加载远程文件的时候分析文件。
      (file-name-handler-alist nil)) 

  (use-package benchmark-init
    :ensure t
    :config
    ;; To disable collection of benchmark data after init is done.
    (add-hook 'after-init-hook 'benchmark-init/deactivate))
  
  ;; basic
  
  (require 'init-base)
  
  (require 'init-ui)
  
  (require 'init-counsel)
  
  (require 'init-evil)

  (require 'init-rime)
  
  (require 'init-shortkey)
  
  (require 'init-snippets)
  
  (require 'init-treemacs)

  (require 'init-company)
  
  ;; languages
  
  (require 'init-org)

  (require 'init-dot)

  (require 'init-plantuml)

  (require 'init-ruby)
  
  ;; (require 'init-golang)
  
  ;; application
  
  (require 'init-dired)
  
  (require 'init-mybase)
  
  (require 'init-mybase-database)
  
  (require 'init-mybase-knowledge)

  
  (require 'init-rss)
  
  (require 'init-vterm)

  (require 'init-calibredb)


  (require 'init-scrolls)
  
  ;; (require 'init-eaf)

  (require 'init-ebook)

  ;; (require 'init-exwm)

  ;; (require 'init-exp)
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; others

(require 'recentf)
(recentf-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(default-input-method "rime")
 '(elfeed-feeds '("http://www.matrix67.com/blog/feed.asp"))
 '(org-agenda-files nil)
 '(package-selected-packages
   '(good-scroll jupyter rspec-mode yari ruby-refactor yard-mode inf-ruby yaml-mode rbenv dired-ranger smartparens geiser valign powerline smart-mode-line-powerline-theme xenops smart-mode-line mini-modeline elfeed-org plantuml-mode graphviz-dot-mode lab-themes org-drill gkroam elfeed exwm-edit rime exwm cnfonts telega nov shrface nav org-ref calibredb emacsql-sqlite names lsp-mode go-rename go-guru go-eldoc company-go go-mode all-the-icons-dired darkroom writeroom-mode pyim olivetti yasnippet posframe ivy-posframe hydra htmlize flycheck company use-package all-the-icons all-the-icons-ivy which-key evil doom-themes doom-modeline counsel hydra rainbow-delimiters pretty-hydra org-bullets general treemacs treemacs-evil treemacs-icons-dired async racer flycheck-rust rust-mode vterm))
 '(which-key-idle-delay 0.3)
 '(which-key-max-description-length 80)
 '(which-key-max-display-columns 2)
 '(which-key-popup-type 'side-window)
 '(which-key-show-docstrings t)
 '(which-key-show-prefix nil)
 '(which-key-side-window-location 'bottom)
 '(which-key-side-window-max-height 8))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:foreground "DodgerBlue")))))
