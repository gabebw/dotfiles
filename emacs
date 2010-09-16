; to quit emacs: Ctrl-X Ctrl-C
; To run scheme after loading this library, do
; M-x scheme
(load-library "xscheme")
;;; Always do syntax highlighting. Why is it called this? WHO KNOWS
(global-font-lock-mode 1)
;;; This is the binary name of my scheme implementation
(setq scheme-program-name "mit-scheme")

;;; QUACK
;(add-to-list 'load-path "/Users/gabe/emacs.d/")
;(require 'quack)
