;; https://github.com/tumashu/pyim

;; (use-package pyim
;;   :after ivy
;;   :config
;;   ;; 设置 ivy 拼音匹配
;;   (defun eh-ivy-cregexp (str)
;;     (concat
;;      (ivy--regex-plus str)
;;      "\\|"
;;      (pyim-cregexp-build str)))
;; 
;;   (setq ivy-re-builders-alist
;;         '((t . eh-ivy-cregexp)))
;; 
;;   )

;; ;; 设置 rime
;; (module-load (expand-file-name "libs/liberime-core.so" user-emacs-directory))
;; 
;; (require 'posframe)
;; (require 'liberime-core)
;; (require 'pyim)
;; 
;; (setq default-input-method "pyim")
;; (setq pyim-page-tooltip 'posframe)
;; (setq pyim-page-length 9)
;; 
;; (liberime-start "/usr/share/rime-data/" (file-truename "~/.emacs.d/pyim/rime/"))
;; (liberime-select-schema "luna_pinyin_simp")
;; (setq pyim-default-scheme 'rime-quanpin)


(provide 'init-pyim)
