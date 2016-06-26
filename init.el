;;;;    Global Settings

;; Prevent emacs droppings
(defvar my-auto-save-folder "~/.emacs.d/auto-save/")
(setq auto-save-list-file-prefix "~/.emacs.d/auto-save/.saves-")
(setq auto-save-file-name-transforms `((".*", my-auto-save-folder t)))
(setq tramp-auto-save-directory my-auto-save-folder)

;; General UI tweaks
(setq longlines-wrap-follows-window-size t)
(global-hl-line-mode 1)
(setq ring-bell-function 'ignore)
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)
(setq default-cursor-type 'bar)


(defadvice counsel-find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defadvice find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


;;; Package initialization

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(defun load-all-packages (package-list)
  (unless package-archive-contents
	(package-refresh-contents))
  (dolist (package package-list) ;Installs missing packages
	(unless (package-installed-p package)
	  (package-install package))))

(setq package-list
      '(projectile
        popwin

        use-package

        ivy
        counsel
        swiper
        
        smartparens
        rainbow-delimiters
        
        better-defaults
        spacemacs-theme
        powerline
        spaceline

        exec-path-from-shell
        bash-completion

        multiple-cursors
        evil-nerd-commenter

        ace-jump-mode

        flycheck
        magit
        
        company
        nlinum
        undo-tree

        google-c-style
        
        haskell-mode
        flycheck-haskell
        company-ghc
        hi2

        python-mode
        anaconda-mode
        company-anaconda
        pyenv-mode
        virtualenvwrapper))

(load-all-packages package-list)

;; Global Package dependent settings
(require 'rainbow-delimiters)
(rainbow-delimiters-mode)

(require 'bind-key)
(bind-keys
 ("C-x C-m" . execute-extended-command)
 ("C-x C-b" . ivy-switch-buffer)
 ("C-o"     . custom/open-line-above)
 ("C-j"     . custom/open-line)
 ("C-a"     . custom/line-beginning)
 ("C-k"     . custom/kill-line)
 ("C-S-k"   . custom/kill-whole-line)
 ("C-c t"   . custom/launch-term)
 ("s-k"     . custom/kill-buffer)
 ("s->"     . nxt)
 ("s-<"     . prv)
 ("s-d"     . sp-kill-sexp)
 ("M-g S"   . magit-stage-file)
 ("M-g C"   . magit-commit)
 ("M-g P"   . magit-push-popup)
 ("M-;"   . evilnc-comment-or-uncomment-lines)
 )

(load-theme 'spacemacs-dark t)

;;;; Package configuration


(defun nlinum-tweak ()
  (setq nlinum--width
		(length (number-to-string
				 (count-lines (point-min) (point-max))))))

(use-package nlinum
  :config
  (add-hook 'prog-mode-hook 'nlinum-mode)
  (setq nlinum-format " %d ")
  (add-hook 'nlinum-mode-hook 'nlinum-tweak)
  )

(use-package powerline
  :config
  (setq-default powerline-default-separator nil))

(use-package smartparens
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode)
  )

(use-package company
  :diminish company-mode
  :config
  (global-company-mode)
  )

(use-package flycheck
  :diminish flycheck-mode
  :config
  (global-flycheck-mode)
  )

(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers)
  :bind
  (("C-s" . swiper)
   ("C-c C-r" . ivy-resume)
   ("<f6>" . ivy-resume)
   ("M-x" . counsel-M-x)
   ("M-y" . counsel-yank-pop)
   ("C-x C-f" . counsel-find-file)
   ("C-h f" . counsel-describe-function)
   ("C-h v" . counsel-describe-variable)
   ("C-h l" . counsel-load-library)
   ("C-h i" . counsel-info-lookup-symbol)
   ("C-S-u" . counsel-unicode-char)
   ("C-c g" . counsel-git)
   ("C-c j" . counsel-git-grep)
   ("C-c k" . counsel-ag)
   ("C-x l" . counsel-locate)
   ("C-S-o" . counsel-rhythmbox)
   ("C-r"   . counsel-expression-history)
   :map read-expression-map
   ("C-r"   . counsel-expression-history))
  )


(use-package popwin
  :config
  (popwin-mode 1)
  (push '("*anaconda-doc*" :width 100 :height 50 :position left)
		popwin:special-display-config)
  )

(use-package projectile
  :config
  (projectile-global-mode +1)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy)
  )

(use-package multiple-cursors
  :bind
  ("C-c C-<" . mc/mark-all-like-this)
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("s-," . mc/skip-previous-like-this)
  ("s-." . mc/skip-previous-like-this)
  ("s-/" . set-rectangular-region-anchor)
  )

(use-package org
  :config
  (setq org-src-fontify-natively t)
  (setq org-src-ask-before-returning-to-edit-buffer nil)
  (setq org-src-window-setup (quote current-window))
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((python . t)))
  )

(use-package haskell-mode
  :config
  (add-hook 'haskell-mode-hook 'turn-on-hi2)
  (add-hook 'haskell-mode-hook  'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (custom-set-variables
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-auto-import-loaded-modules t)
   '(haskell-process-log t))
  :bind
  ("C-c C-c" . haskell-process-load-or-reload)
  ("C-c C-z" . haskell-interactive-switch)
  )

(use-package c-mode
  :config
  (setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode t)
  (setq c-default-style "linux"
		c-basic-offset 4)
  (add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))
  (add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
  :bind
  ("C-S-{" . custom/open-c-block)
  )

(defun custom/open-c-block ()
  ;; (id action context)
  (interactive)
  (insert "{")
  (newline)
  (newline)
  (indent-according-to-mode)
  (insert "}")
  (indent-according-to-mode)
  (previous-line)
  (indent-according-to-mode))


(use-package python
  :config
  (setq python-indent-guess-indent-offset nil)
  (setq python-indent-offset 4)
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'eldoc-mode)
  (pyenv-mode)
  )

(use-package virtualenvwrapper
  :config
  (venv-initialize-interactive-shells) ;; if you want interactive shell support
  (setq venv-location "~/Development/Virtual-Environments/")
)

(use-package latex-mode
  :config
  (setq-default TeX-master nil)
  (setq TeX-parse-self t)
  (setq TeX-auto-save t)
  )


;;;; Custom functions

(setq primary-modes
      '("shell-mode"
        "inferior-python-mode"
        "inferior-octave-mode"
        "magit-mode"
        "magit-status-mode"))

(defun custom/next-buffer (buff-func)
      "next-buffer, only skip *Messages*"
      (funcall buff-func)
      (while (and (not (-contains? primary-modes (symbol-name major-mode)))
                  (= 42 (aref (buffer-name) 0)))
        (funcall buff-func)))

(defun configure/emacs ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun reload/emacs ()
  (interactive)
  (org-babel-load-file "~/.emacs.d/settings.org"))

(defun nxt ()
  (interactive)
  (custom/next-buffer (function next-buffer)))

(defun prv ()
  (interactive)
  (custom/next-buffer (function previous-buffer)))

(defun custom/kill-buffer ()
  (interactive)
  (when (not (equal "agenda.org" (buffer-name)))
    (kill-this-buffer)
    (nxt))
  )

(defun custom/current-mode ()
  (interactive)
  (message (symbol-name major-mode)))

(defun ssh/ews ()
  (interactive)
  (find-file "/ssh:akmishr2@remlnx.ews.illinois.edu:/home/akmishr2"))

(defun custom/refresh ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))

(defun custom/kill-line ()
  "Kills line and fixes indentation"
  (interactive)
  (kill-line)
  (indent-according-to-mode))

(defun custom/kill-whole-line ()
  (interactive)
  (kill-whole-line)
  (beginning-of-line-text))

(defun custom/line-beginning ()
  "Move point to the beginning of text on the current line; if that is already
      the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (beginning-of-line-text)
    (when (eq pt (point))
      (beginning-of-line))))

(defun custom/open-line ()
  "Insert an empty line after the current line.
       Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun custom/open-line-above ()
  "Insert an empty line above the current line.
      Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun custom/launch-term ()
  (interactive)
  (call-process "termite" nil 0 nil "-d" default-directory))


(defun configure/xmonad ()
  (interactive)
  (find-file "~/.xmonad/xmonad.hs"))

(defun configure/nix-local ()
  (interactive)
  (find-file "~/.nixpkgs/config.nix"))

(defun configure/nix-global ()
  (interactive)
  (find-file "/etc/nixos/configuration.nix"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(python-shell-interpreter "python"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
