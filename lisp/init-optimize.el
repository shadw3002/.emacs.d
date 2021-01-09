;; Optimize Emacs GC
;; 
;; The default value of Emacs's GC gabage collection threshold is quite small (800 KiB)
;; How to setup a appropriate value? Here is two questions:
;; 1. A higher threshold: more annoying hangs of the whole universe.
;; 2. A Lower threshold: more numbers of GC runs
;; 
;; ref: http://akrl.sdf.org/#org2a987f7

(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

;; Set garbage collection threshold to 256 MiB.
(setq gc-cons-threshold #x10000000)

(defvar k-gc-timer
  (run-with-idle-timer 15 t
                       (lambda ()
                         ;; (message "Garbage Collector has run for %.06fsec")
                                  (k-time (garbage-collect))
                                  )))



;; Increase the amount of data from the process
;;
;; `lsp-mode' gains

(setq read-process-output-max (* 1024 1024))


;; Disable bidirectional text rendering
;;
;; Tricks stolen from
;; https://github.com/CSRaghunandan/.emacs.d/blob/master/setup-files/setup-optimizations.el
;;
;; Disable bidirectional text rendering for a modest performance boost. Of
;; course, this renders Emacs unable to detect/display right-to-left languages
;; (sorry!), but for us left-to-right language speakers/writers, it's a boon.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

(provide 'init-optimize)
