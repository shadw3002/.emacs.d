
(use-package plantuml-mode
  :ensure t
  :mode "\\.plu\\'"
  :config
  (setq plantuml-default-exec-mode 'executable)
  (setq plantuml-executable-path "/usr/bin/plantuml")
  (setq org-plantuml-jar-path "/usr/share/plantuml/lib/plantuml.jar")
  )

(provide 'init-plantuml)
