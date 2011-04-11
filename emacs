; vim:syntax=lisp
; to quit emacs: Ctrl-X Ctrl-C
; To run scheme after loading this library, do
; M-x scheme
(load-library "xscheme")
;;; This is the binary name of my scheme implementation
(setq scheme-program-name "mit-scheme")

;;; Always do syntax highlighting. Why is it called this? WHO KNOWS
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t) ;;all possible colors

; SLIME
; your Lisp system
(setq inferior-lisp-program "/usr/local/bin/sbcl")
  ;(concat (shell-command-to-string "brew --prefix") "/bin/sbcl"))
(add-to-list 'load-path "~/.dotfiles/emacs-plugins/slime/")  ; your SLIME directory
; load SBCL faster
; see: http://common-lisp.net/project/slime/doc/html/Loading-Swank-faster.html#Loading-Swank-faster
; Or, if you don't want to look at the webpage:
;   shell$ sbcl
;   * (mapc 'require '(sb-bsd-sockets sb-posix sb-introspect sb-cltl2 asdf))
;   * (save-lisp-and-die "sbcl.core-for-slime")

;(setq slime-lisp-implementations
;           '((sbcl ("sbcl" "--core" "/Users/gabe/.dotfiles/sbcl.core-for-slime"))))

(require 'slime-autoloads) ; only load SLIME on demand (M-x slime)
;(slime-setup) ; basic setup
;(slime-setup '(slime-repl)) ; load the repl too
; slime-fancy loads almost everything, including the REPL
(slime-setup '(slime-fancy))

; To exit SLIME, type a comma to get in the minibuffer, then type
; `sayoonara` and hit ENTER. Voila, back to Emacs!


; Indent on enter
; binding to (kbd "RET") might be more xplatform
(global-set-key "\C-m" 'newline-and-indent)


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))
