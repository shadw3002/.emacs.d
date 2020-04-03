(use-package eaf
  :load-path "/usr/share/emacs/site-lisp/eaf" 
  :custom
  (eaf-find-alternate-file-in-dired t)
  :config
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding)

  (use-package htmlize)
  
  )

(provide 'init-eaf)
