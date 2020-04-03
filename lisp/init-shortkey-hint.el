
(use-package which-key
  :diminish which-key-mode
  :bind
  (:map help-map ("C-h" . which-key-C-h-dispatch))
  :hook
  (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom)
  (which-key-show-docstrings t)
  (which-key-max-display-columns 2)
  (which-key-show-prefix nil)
  (which-key-side-window-max-height 8)
  (which-key-max-description-length 80))




(provide 'init-shortkey-hint)