(use-package company
  :ensure t
  :hook
  (prog-mode . company-mode)
  (org-mode . company-mode)
  :config
  (setq company-tooltip-align-annotations t))

(provide 'init-company)
