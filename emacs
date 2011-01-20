; vim:syntax=lisp
; to quit emacs: Ctrl-X Ctrl-C
; To run scheme after loading this library, do
; M-x scheme
(load-library "xscheme")
;;; This is the binary name of my scheme implementation
(setq scheme-program-name "mit-scheme")

;;; Always do syntax highlighting. Why is it called this? WHO KNOWS
(global-font-lock-mode 1)

; SLIME
; your Lisp system
(setq inferior-lisp-program
  (concat (shell-command-to-string "brew --prefix") "/bin/sbcl"))
(add-to-list 'load-path "~/.dotfiles/emacs-plugins/slime/")  ; your SLIME directory
; load SBCL faster
; see: http://common-lisp.net/project/slime/doc/html/Loading-Swank-faster.html#Loading-Swank-faster
; Or, if you don't want to:
; $ sbcl
; * (mapc 'require '(sb-bsd-sockets sb-posix sb-introspect sb-cltl2 asdf))
;
; (SB-BSD-SOCKETS SB-POSIX SB-INTROSPECT SB-CLTL2 ASDF)
; * (save-lisp-and-die "sbcl.core-for-slime")
; [undoing binding stack and other enclosing state... done]
; ...other stuff, then it exits

(setq slime-lisp-implementations
           '((sbcl ("sbcl" "--core" "sbcl.core-for-slime"))))
(require 'slime-autoloads) ; only load SLIME on demand (M-x slime)
;(slime-setup)
(slime-setup '(slime-repl))

; To exit SLIME, type a comma to get in the minibuffer, then type
; `sayoonara` and hit ENTER. Voila, back to Emacs!
