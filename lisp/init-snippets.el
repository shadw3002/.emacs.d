(use-package yasnippet
  :diminish yas-minor-mode
  :hook (after-init . yas-global-mode)
  :config
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets"
          ))
  )

(provide 'init-snippets)
