(require 'cl-lib)

(use-package vterm
  :config
  (setq vterm-shell "zsh")
  (add-hook 'vterm-set-title-functions 'vterm--rename-buffer-as-title)
  (general-define-key
  :prefix "C-c"
  "t" 'vterm)
)


(defun vterm--rename-buffer-as-title (title)
  (rename-buffer (format "vterm @ %s" title) t))



(provide 'init-vterm)
