(use-package racer
  :hook
  (racer-mode . eldoc-mode)
  )

(use-package rust-mode
  :hook
  (rust-mode . company-mode)
  (rust-mode . racer-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))



(use-package flycheck-rust
  :hook
  (flycheck-mode . flycheck-rust-setup))

(provide 'init-rust)
