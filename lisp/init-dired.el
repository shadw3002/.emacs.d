
(require 'dired)

(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

;; 让dired mode始终占据一个缓冲区
(put 'dired-find-alternate-file 'disabled nil)

;; 主动加载 Dired Mode
;; (require 'dired)
;; (defined-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

;; 延迟加载
(with-eval-after-load 'dired
    (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))


(provide 'init-dired)
