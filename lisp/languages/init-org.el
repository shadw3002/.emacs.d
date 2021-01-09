;; https://zzamboni.org/post/beautifying-org-mode-in-emacs/

(use-package org
  :init
  ;; 修正中文行内格式化
  (setq org-emphasis-regexp-components
      ;; markup 记号前后允许中文
      (list (concat " \t('\"{"            "[:nonascii:]")
            (concat "- \t.,:!?;'\")}\\["  "[:nonascii:]")
            " \t\r\n,\"'"
            "."
            1))

  :preface
  (defun hot-expand (str &optional mod)
    "Expand org template.

STR is a structure template string recognised by org like <s. MOD is a
string with additional parameters to add the begin line of the
structure element. HEADER string includes more parameters that are
prepended to the element after the #+HEADER: tag."
    (let (text)
      (when (region-active-p)
        (setq text (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
      (insert str)
      (if (fboundp 'org-try-structure-completion)
          (org-try-structure-completion) ; < org 9
        (progn
          ;; New template expansion since org 9
          (require 'org-tempo nil t)
          (org-tempo-complete-tag)))
      (when mod (insert mod) (forward-line))
      (when text (insert text))))

  :hook
  (after-init . org-indent-mode)
  (org-mode . (lambda ()
                (interactive)
                (variable-pitch-mode t)
                (setq line-spacing 3)
                ;; (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
                (set-face-attribute 'org-quote nil :inherit 'fixed-pitch)
                (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
                (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
                (set-face-attribute 'org-block-begin-line nil :slant 'italic :inherit 'fixed-pitch)
                ;; (set-face-attribute 'org-block-background nil :inherit 'fixed-pitch)
                ))
  (org-mode .(lambda ()
               ;; (toggle-truncate-lines)
               (setq truncate-lines nil)
               ))
  ;; (org-mode . xenops-mode)
  
  :bind
  ("<f12>" . org-agenda)
  ("C-c c" . org-capture)

  :config

  ;; (add-hook 'text-mode-hook 'turn-on-visual-line-mode)

  ;; 设置所有图像显示大小为宽度的三分之一
  ;; (setq org-image-actual-width (/ (display-pixel-width) 3))
  ;; in this way we can control image's width with attr_org
  (setq org-image-actual-width nil)
  
  ;; 设置链接打开方式
  (setq org-link-frame-setup
        '((vm . vm-visit-folder)
          (vm-imap . vm-visit-imap-folder)
          (gnus . gnus)
          (file . find-file)
          (wl . wl)))

  ;; org 9.2 后代码块补全需要手动开启
  (require 'org-tempo)
  
  ;; (add-hook 'org-mode-hook #'olivetti-mode)


  ;; 自动缩进，实际没有缩进，只是显示效果。
  (setq org-startup-indented t)
  
  ;; org-table 字体对齐
  ;; (set-face-attribute 'org-table nil :family "Sarasa Mono SC" :height 140)

  (setq org-src-fontify-natively t)


  (general-define-key
    :keymaps 'org-mode-map
    :prefix "C-c"
    "i" 'org-toggle-inline-images
    "l" 'org-toggle-latex-fragment)



  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (haskell . t)
      (latex . t)
      (lilypond . t)
      (dot . t)
      (scheme . t)
      (ditaa . t)
      (plantuml . t)
      (shell . t)))

  ;; org-babel run scheme
  (setq geiser-default-implementation 'guile)
  
  (setq org-ditaa-jar-path (expand-file-name "~/.emacs.d/others/ditaa-0.11.jar"))

  ;; latex tikz

  
  ;; latex format 中文支持
  (setq org-latex-packages-alist
        '(("fontset=Source Code Pro,UTF8" "ctex" t)))

  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-preview-latex-process-alist
        '((dvisvgm :programs
                   ("xelatex" "dvisvgm")
                   :description "xdv > svg" :message "you need to install the programs: xelatex and dvisvgm." :use-xcolor t :image-input-type "xdv" :image-output-type "svg" :image-size-adjust
                   (1.7 . 1.5)
                   :latex-compiler
                   ("xelatex -no-pdf -interaction nonstopmode -output-directory %o %f")
                   :image-converter
                   ("dvisvgm %f -n -b min -c %S -o %O"))
          (imagemagick :programs
                       ("xelatex" "convert")
                       :description "pdf > png" :message "you need to install the programs: xelatex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                       (1.0 . 1.0)
                       :latex-compiler
                       ("xelatex -interaction nonstopmode -output-directory %o %f")
                       :image-converter
                       ("convert -density %D -trim -antialias %f -quality 100 %O")))) 
  
  
  ;; (setq org-format-latex-options (plist-put org-format-latex-options :scale1.5))
  


  ;; hide the emphasis markup
  (setq org-hide-emphasis-markers nil)

  ;; replacing list markers
  (font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; 标题折叠符号
  (setq org-ellipsis "  ")

  ;; tikz
  (setq org-latex-create-formula-image-program 'imagemagick)
)

;; 修复 variable-pitch 对 org-indent-mode 的影响
(use-package org-indent
  :config
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
)

;; 标题美化
(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :init
  ;; (setq org-bullets-bullet-list '("⦿" "○" "✸" "✿" "◆"))
  (setq org-bullets-bullet-list '("⦿"))
  :config

  ;; 标题颜色 DodgerBlue
  ;; (custom-theme-set-faces 'user
  ;;                       `(org-level-1 ((t (:foreground "SaddleBrown")))))
  ;; (setq org-n-level-faces 1)

  )



;; 图片插入支持
(use-package org-download
  :config
  (setq org-download-image-dir "images")
  (setq org-download-display-inline-images nil)
  (setq org-download-image-org-width 150))

(use-package table)

(use-package doom-themes
  :config
  (doom-themes-org-config)
  )

(use-package valign
  :config
  (setq valign-fancy-bar t)
  (add-hook 'org-mode-hook #'valign-mode))

;; latex preview
;; (add-hook 'latex-mode-hook #'xenops-mode)
;; (add-hook 'LaTeX-mode-hook #'xenops-mode)
;;
;; (use-package xenops
;;   :config
;;   (plist-put org-format-latex-options :scale 2.4)
;;   )

(defun markdown-convert-buffer-to-org ()
  "Convert the current buffer's content from markdown to orgmode format and save it with the current buffer's file name but with .org extension."
  (interactive)
  (shell-command-on-region (point-min) (point-max)
                             (format "pandoc -f markdown -t org -o %s"
                                     (concat (file-name-sans-extension (buffer-file-name)) ".org"))))


(provide 'init-org)
