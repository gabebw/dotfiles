; vim:syntax=lisp
; to quit emacs: Ctrl-X Ctrl-C
; To run scheme after loading this library, do
; M-x scheme
(load-library "xscheme")
;;; This is the binary name of my scheme implementation
(setq scheme-program-name "mit-scheme")

;;; Always do syntax highlighting. Why is it called this? WHO KNOWS
(global-font-lock-mode 1)
