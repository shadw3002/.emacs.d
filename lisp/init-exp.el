(use-package gkroam
  :ensure t
  :init
  (setq gkroam-root-dir "~/Temp/gkroam/org/"
        gkroam-pub-dir "~/Temp/gkroam/site/")
  :bind
  (("C-c r I" . gkroam-index)
   ("C-c r d" . gkroam-daily)
   ("C-c r f" . gkroam-find)
   ("C-c r i" . gkroam-insert)
   ("C-c r c" . gkroam-capture)
   ("C-c r e" . gkroam-link-edit)
   ("C-c r n" . gkroam-smart-new)
   ("C-c r t" . gkroam-toggle-brackets)
   ("C-c r g" . gkroam-update)
   ("C-c r G" . gkroam-update-all))
  :config
  ;; when this minor mode is on, show and hide brackets dynamically.
  (gkroam-dynamic-brackets-mode -1))

(provide 'init-exp)
