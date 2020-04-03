(use-package company
  :hook
  (prog-mode . company-mode)
  :config
  (setq company-tooltip-align-annotations t))

(provide 'init-company)
