;; https://writequit.org/denver-emacs/presentations/2017-04-11-ivy.html

(use-package evil
  :bind ("C-s" . counsel-grep-or-swiper)
  :hook (after-init . evil-mode))

(provide 'init-evil)