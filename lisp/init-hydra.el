(use-package hydra
  :commands (hydra-default-pre
             hydra-keyboard-quit
             hydra--call-interactively-remap-maybe
             hydra-show-hint
             hydra-set-transient-map))

(use-package pretty-hydra)

(provide 'init-hydra)