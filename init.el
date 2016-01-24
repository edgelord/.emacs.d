(require 'org)
(org-babel-load-file
 (expand-file-name "settings.org" user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(background-color "#202020")
 '(background-mode dark)
 '(cursor-color "#cccccc")
 '(foreground-color "#cccccc")
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(linum-format "%3i")
 '(magit-popup-use-prefix-argument (quote default))
 '(neo-theme (quote arrow))
 '(powerline-color1 "#3d3d68")
 '(powerline-color2 "#292945"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
