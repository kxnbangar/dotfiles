;; Title: Key Bindings of the KXN Stumpwm Configuration
;; Author: Arsh Bangar

(set-prefix-key (kbd "S-SPC"))

(defvar *apps-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "c") "exec kitty")
    (define-key m (kbd "e") "emacs")
    (define-key m (kbd "f") "firefox")
    (define-key m (kbd "o") "exec okular")
    m))

(defvar *end-session-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "q") "quit-confirm")
    (define-key m (kbd "s") "exec loginctl suspend")
    m))

(define-key *root-map* (kbd "a") '*apps-bindings*)
(define-key *root-map* (kbd "q") '*end-session-bindings*)
