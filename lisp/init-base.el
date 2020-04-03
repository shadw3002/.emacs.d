(use-package async)

;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; No need for ~ files when editing
(setq create-lockfiles nil)

;; 记录了上次打开文件时光标停留在第几行、第几列
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(setq default-tab-width 4)

(setq-default indent-tabs-mode nil)

(setq c-basic-offset 4)

(provide 'init-base)
