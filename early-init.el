;;; early-init.el -*- lexical-binding: t; -*-

;; Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; Package initialize occurs automatically, before `user-init-file' is
;; loaded, but after `early-init-file'. We handle package
;; initialization, so we must prevent Emacs from doing it early!
(setq package-enable-at-startup nil)

;; Inhibit resizing frame
;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
(setq frame-inhibit-implied-resize t)

;; Faster to disable these here (before they've been initialized)
;; Set the frame parameters before it's drawing. Save times for redrawing.
(setq default-frame-alist '((tool-bar-lines . 0)
			    (menu-bar-lines . 0)
                            (font . "Roboto Mono 18")
                            (internal-border-width . 18)
                            (left-fringe    . 3)
                            (right-fringe   . 0)
                            (vertical-scroll-bars . nil)))

;; Open config org file
(defun open-config-file ()
  (interactive)
  (find-file (expand-file-name "config.org" user-emacs-directory)))

;; Reload config from `init.el`
(defun reload-init-file ()
  (interactive)
  (load-file user-init-file))

(setq org-roam-v2-ack t)
