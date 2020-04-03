
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
  (org-mode . (lambda () (setq truncate-lines nil)))

  :bind
  ("<f12>" . org-agenda)
  ("C-c c" . org-capture)

  :config
  ;; org-table 字体对齐
  ;; (set-face-attribute 'org-table nil :family "Sarasa Mono SC" :height 140)

  (setq org-src-fontify-natively t)

  (general-define-key
    :keymaps 'org-mode-map
    :prefix "C-c"
    "i" 'org-toggle-inline-images
    "l" 'org-toggle-latex-fragment)


  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (haskell . t)
      (latex . t)
      (lilypond . t)
      (dot . t)
      (ditaa . t)))

  (setq org-ditaa-jar-path (expand-file-name "~/.emacs.d/others/ditaa-0.11.jar"))


  ;; 标题美化
  ;; (use-package org-bullets
  ;;   :hook (org-mode . org-bullets-mode)
  ;;   :init
  ;;   ;; (setq org-bullets-bullet-list '("⦿" "○" "✸" "✿" "◆"))
  ;;   (setq org-bullets-bullet-list '("⦿"))
  ;;  )

  ;; 标题折叠符号
  (setq org-ellipsis " ▼ ")

  ;; 标题颜色
  (custom-theme-set-faces 'user
                        `(org-level-1 ((t (:foreground "RosyBrown")))))
  (setq org-n-level-faces 1)

  ;; hide the emphasis markup
  ;; (setq org-hide-emphasis-markers nil)

  ;; replacing list markers
  (font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))


  ;; 图片插入支持
  (use-package org-download
    :config
    (setq org-download-image-dir "images")
    (setq org-download-display-inline-images nil)
    (setq org-download-image-org-width 150))

  (use-package table)
)

(provide 'init-org)
