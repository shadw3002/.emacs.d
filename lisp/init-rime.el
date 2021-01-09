(use-package rime
  :custom
  (default-input-method "rime")
  :config
  (setq rime-share-data-dir "/usr/share/rime-data")
  (setq rime-user-data-dir "~/.emacs.d/rime")
  (setq rime-posframe-properties
        (list :background-color "#333333"
              :foreground-color "#dcdccc"
              ;; :font "WenQuanYi Micro Hei Mono-14"
              :internal-border-width 10))
  
  (setq rime-disable-predicates
        '(
          ;; 在 evil-mode 的非编辑状态下 
          rime-predicate-evil-mode-p
          ;; 在英文字符串之后（必须为以字母开头的英文字符串）
          rime-predicate-after-alphabet-char-p
          ;; 在 prog-mode 和 conf-mode 中除了注释和引号内字符串之外的区域
          rime-predicate-prog-in-code-p
          ;; 当要在任意英文字符之后输入符号时
          rime-predicate-punctuation-after-ascii-p
          
          
          ;; 将要输入的为大写字母时
          rime-predicate-current-uppercase-letter-p
          ;; 在 (La)TeX 数学环境中或者输入 (La)TeX 命令时
          rime-predicate-tex-math-or-command-p
          ;; 如果激活了一个 hydra keymap
          rime-predicate-hydra-p
          ))
  
  (setq rime-inline-predicates
        '(
          ;; 光标在一个中文+空格的后面
          rime-predicate-space-after-cc-p
          ))

    

  (setq rime-inline-ascii-trigger 'shift-l)
  
  (setq default-input-method "rime"
        rime-show-candidate 'posframe)
  )

(provide 'init-rime)
