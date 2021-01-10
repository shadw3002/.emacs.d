(use-package dired
  :ensure t
  :init
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always
        dired-dwim-target t)

  :config
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  ;; 自动猜测目标路径
  (setq dired-dwim-target t)
  
  ;; 让dired mode始终占据一个缓冲区
  (put 'dired-find-alternate-file 'disabled nil)

(use-package dired-ranger
  :ensure t
  :bind (:map dired-mode-map
              ("W" . dired-ranger-copy)
              ("X" . dired-ranger-move)
              ("Y" . dired-ranger-paste)))  

  ;; dired 高亮
  (use-package diredfl
    :ensure t
    :config (diredfl-global-mode t))

  (use-package all-the-icons-dired
    :ensure t
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))


  
  )

(provide 'init-dired)
