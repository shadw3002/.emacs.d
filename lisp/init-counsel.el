;; counsel includes ivy and swiper. 
(use-package counsel
  :ensure t
  :hook
  (after-init . ivy-mode)
  (after-init . counsel-mode)
  
  :config

  (use-package ivy-posframe
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
  (ivy-posframe-mode 1)
  )
  
  (general-define-key
  :prefix "C-c"
  "b" 'counsel-switch-buffer
  "r" 'counsel-recentf
  "s" 'counsel-mybase-search)
  
  (setq counsel-more-chars-alist 1) 
  
  (defun counsel-mybase-search-function (str)
    (or
     (ivy-more-chars)
     (progn
       (counsel--async-command
        ;; "rg -g main.org --files /mnt/data/Base | rg --color never %s"
        (format "find /mnt/data/Base -type d ! -name 'ltximg' ! -name 'img' ! -name 'images' -iname '*%s*'"
                (counsel--elisp-to-pcre
                 (ivy--regex str))))
       '("" "working..."))))

  (defun counsel-mybase-search-transformer (str)
    "Only show dir name."
    (car (last (split-string str "/")))
   )

  
  ;;;###autoload
  (defun counsel-mybase-search (&optional initial-input)
    "Call the \"locate\" shell command.
  INITIAL-INPUT can be given as the initial minibuffer input."
    (interactive)
    (ivy-read "Locate: " #'counsel-mybase-search-function
              :initial-input initial-input
              :dynamic-collection t
              ;; :history 'counsel-locate-history
              :action (lambda (file)
                        (with-ivy-window
                          (when file
                            (find-file (concat file "/main.org")))))
              :unwind #'counsel-delete-process
              :caller 'counsel-mybase-search))

  (ivy-configure 'counsel-mybase-search
    :display-transformer-fn #'counsel-mybase-search-transformer
    :more-chars 1)
  
  
)


(provide 'init-counsel)
