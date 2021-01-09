;; counsel includes ivy and swiper. 
(use-package counsel
  :ensure t
  :hook
  (after-init . ivy-mode)
  (after-init . counsel-mode)
  
  :config

  ;; all-the-icons 美化
  ;; https://github.com/asok/all-the-icons-ivy
  (use-package all-the-icons-ivy
    :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))
  
  ;; 移动搜索框位置
  ;; https://github.com/tumashu/ivy-posframe
  ;; (use-package ivy-posframe
  ;;   :config
  ;; 
  ;;   ;; 显示位置为居中，
  ;;   (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
  ;; 
  ;;   ;; 设置边框
  ;;   (setq ivy-posframe-parameters
  ;;     '((left-fringe . 8)
  ;;       (right-fringe . 8)))
  ;;   
  ;;   (ivy-posframe-mode 1)
  ;; )
  
  
  (general-define-key
  :prefix "C-c"
  "b" 'counsel-switch-buffer
  "r" 'counsel-recentf
  )

  ;; 显示搜索结果至少输入 1 个字符
  (setq counsel-more-chars-alist 1) 
  
  
)

;; 拼音支持
;; from https://emacs-china.org/t/topic/6069/23
(use-package pyim
  :after ivy
  :config

  (defun eh-ivy-cregexp (str)
    (let ((x (ivy--regex-plus str))
          (case-fold-search nil))
      (if (listp x)
          (mapcar (lambda (y)
                    (if (cdr y)
                        (list (if (equal (car y) "")
                                  ""
                                (pyim-cregexp-build (car y)))
                              (cdr y))
                      (list (pyim-cregexp-build (car y)))))
                  x)
        (pyim-cregexp-build x))))
  
  (setq ivy-re-builders-alist
        '((t . eh-ivy-cregexp))))

(provide 'init-counsel)
