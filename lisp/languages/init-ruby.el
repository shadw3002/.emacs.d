;; Integrate rbenv
(use-package rbenv
  :hook (after-init . global-rbenv-mode)
  :init (setq rbenv-show-active-ruby-in-modeline nil
              rbenv-executable "rbenv"))

;; YAML mode
(use-package yaml-mode)

;; Run a Ruby process in a buffer
(use-package inf-ruby
  :hook ((ruby-mode . inf-ruby-minor-mode)
         (compilation-filter . inf-ruby-auto-enter)))

;; Ruby YARD comments
(use-package yard-mode
  :diminish
  :hook (ruby-mode . yard-mode))

;; Ruby refactoring helpers
(use-package ruby-refactor
  :diminish
  :hook (ruby-mode . ruby-refactor-mode-launch))

;; Yet Another RI interface for Emacs
(use-package yari
  :bind (:map ruby-mode-map ([f1] . yari)))

;; RSpec
(use-package rspec-mode
  :diminish
  :commands rspec-install-snippets
  :hook (dired-mode . rspec-dired-mode)
  :config (with-eval-after-load 'yasnippet
            (rspec-install-snippets)))

(provide 'init-ruby)
