(setq package-enable-at-startup nil
      inhibit-startup-message t
      frame-resize-pixelwise  t
      package-native-compile  t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(blink-cursor-mode 0)
(display-line-numbers-mode 'toggle)
(load-theme 'wombat t)
(server-start)

(add-hook 'before-save-hook #'whitespace-cleanup)
(setq-default sentence-end-double-space nil)
(global-subword-mode 1)
(setq scroll-conservatively 1000)
(setq backup-directory-alist `(("." . ,(expand-file-name "./tmp/backups/"
							 user-emacs-directory))))
(setq delete-by-moving-to-trash t)
(setq initial-scratch-message nil)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" default))
 '(package-selected-packages '(slime lua-mode magit ## spacemacs-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'set-goal-column 'disabled nil)
