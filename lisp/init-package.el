(require 'cl)

(require 'package)

(package-initialize)
;; 防止在 init 文件加载之后，再一次加载插件
(setq package-enable-at-startup nil)

(setq package-archives '(
    ("gnu"   . "http://elpa.emacs-china.org/gnu/")
    ("melpa" . "http://elpa.emacs-china.org/melpa/")
    ("org"   . "https://orgmode.org/elpa/")
))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))



(provide 'init-package)
