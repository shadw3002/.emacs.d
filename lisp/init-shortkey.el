;; 方便定义快捷键
(use-package general
  :ensure t)

;; 定义临时快捷键 state
(use-package hydra
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map))

;; pretty-hydra provides a macro pretty-hydra-define to make it easy to create hydras with a pretty table layout with some other bells and whistles
(use-package pretty-hydra)

;; 提示快捷键
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

(provide 'init-shortkey)
