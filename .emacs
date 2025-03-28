;; Set up package list
(require 'package)
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(add-to-list `load-path "~/.emacs.d/MCSH")

(setq package-enable-at-startup nil)
(package-initialize)

;; Set up use package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))


;; My theme!
(load-theme 'misterioso)
;; (load-theme 'wombat)

;; Day and night

(defun disable-all-themes ()
  "disable all active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(defun day () "Make it usefull in bright enviornment"
       (interactive)
       (disable-all-themes)
       (load-theme 'leuven)
       (powerline-reset))

(defun afternoon () "Just a darkish theme"
       (interactive)
       (disable-all-themes)
       (load-theme 'tango-dark)
       (powerline-reset))

(defun night () "Take it back!!!"
       (interactive)
       (disable-all-themes)
       (load-theme 'misterioso)
       (powerline-reset))

(defun altnight () "For greener nights!"
       (interactive)
       (disable-all-themes)
       (load-theme 'wombat)
       (powerline-reset))

(defun latenight () "Just a really dark theem"
       (interactive)
       (disable-all-themes)
       (load-theme 'deeper-blue)
       (powerline-reset))

(defun MCSH/org-reset-agenda-files () "Set back the original agenda files"
       (setq org-agenda-files (list "~/src/TODO.org" "~/src/personal/schedule.org"))
       )

(defun org-sole-agenda () "Set the current buffer as the only agenda file"
       (interactive)
       (setq org-agenda-files (list (file-truename (buffer-file-name)))))

(defun org-default-agenda ()
  (interactive)
  (MCSH/org-reset-agenda-files))

(defun org-add-to-agenda () "Add the current buffer to agenda"
     (interactive)
     (add-to-list 'org-agenda-files (file-truename (buffer-file-name))))

(use-package org
  :ensure t
  :config
  (setq org-log-done t)
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (define-key global-map "\C-cc" 'org-capture)
  (define-key global-map "\C-cb" 'org-iswitchb)
  ;; Agenda file
  ; (setq org-agenda-files (list "~/src/TODO.org" "~/src/personal/schedule.org"))
  (MCSH/org-reset-agenda-files)
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-start-day "-1d")
  (add-to-list 'org-modules 'org-habit t)
  )

(use-package evil
  :ensure t
  :config
  ;;(define-key evil-normal-state-map (kbd "i") 'evil-emacs-state)
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)
  (define-key evil-emacs-state-map (kbd "<escape>") 'evil-normal-state)
  (define-key evil-normal-state-map (kbd "<f3>") 'neotree-toggle)
  (evil-mode)
  )

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'org-mode-hook
            (lambda ()
              (electric-indent-local-mode -1)
              (visual-line-mode)))
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; scaling images

;; (setq org-image-actual-width 500)
(setq org-image-actual-width nil)
  
;; Scaling fonts

(set-face-attribute 'default nil :height 110)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

(defun zoomin ()
  (interactive)
  (set-face-attribute 'default nil :height 160))

(defun zoomout ()
  (interactive)
  (set-face-attribute 'default nil :height 110))

;; Remove the useless stuff
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Interactively do things
;; (setq ido-enable-flex-matching t)
;; (ido-mode 1)

;; (use-package flx-ido
;;    :ensure t
;;    :init (setq ido-enable-flex-matching t
;;                ido-use-faces nil)
;;    :config (flx-ido-mode 1))


;; (use-package smex
;;   :ensure t
;;   :init (smex-initialize)
;;   :bind ("M-x" . smex)
;;   ("M-X" . smex-major-mode-commands))

;; JSX
(use-package rjsx-mode
  :ensure t
  :config
  (defadvice js-jsx-indent-line (after js-jsx-indent-line-after-hack activate)
  "Workaround sgml-mode and follow airbnb component style."
  (save-excursion
    (beginning-of-line)
    (if (looking-at-p "^ +\/?> *$")
        (delete-char sgml-basic-offset))))
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("containers\\/.*\\.js\\'" . rjsx-mode))
  (add-to-list 'auto-mode-alist '("src\\/.*\\.js\\'" . rjsx-mode))
  )


(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.mjs\\'" . js2-mode)))

;; Helm
(use-package helm
  :ensure t
  :config
  (helm-mode 1)

  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-c C-b") 'helm-buffers-list)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  ;; (setq helm-display-function 'helm-display-buffer-in-own-frame
  ;;      Helm-display-buffer-reuse-frame t
  ;;      helm-use-undecorated-frame-option t)
  )

(use-package helm-flx
  :ensure t
  :config
  (setq helm-flx-for-helm-find-files t ;; t by default
        helm-flx-for-helm-locate nil) ;; nil by default
  (helm-flx-mode 1)
  )

;; No default backup
(setq backup-inhibited nil
      make-backup-files nil
      auto-save-default nil
      auto-save-list-file-prefix nil)

;; javascript mode
(setq js-indent-level 2)
(setenv "NODE_NO_READLINE" "1")

;; Auto pair
(electric-pair-mode 1)
(show-paren-mode 1)

;; Add keywords
(font-lock-add-keywords 'js-mode
   '(("\\<async\\>" 0 'font-lock-keyword-face prepend)
     ("\\<await\\>" 0 'font-lock-keyword-face prepend)))

;; Highlight stuff
(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode 1)
  )

;; Window
(windmove-default-keybindings)

;; Smooth scrolling
(use-package smooth-scrolling
  :ensure t
  :config
  (smooth-scrolling-mode 1)
  (setq smooth-scroll-margin 3)
  )

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time

(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling

(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Powerline
(add-to-list `load-path "~/.emacs.d/vendor/powerline")
(require 'powerline)
;; ;; (powerline-default-theme)

(require 'powerline-MCSH)

;; Set custom file
(setq custom-file "~/.emacs.d/.custom.el")
(load custom-file)

;; Dashboard
(require 'scratchify-MCSH)

;; SAM
(require 'sam)

;; No tabs
(setq-default indent-tabs-mode nil)

;; YAML MODE
(use-package yaml-mode
  :ensure t)

;; (require 'org-team)

;; ESC
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

;; Ask "y" or "n" instead of "yes" or "no". Yes, laziness is great.
(fset 'yes-or-no-p 'y-or-n-p)

;; Natural spliting
(defun MCSH/split-right () "Split right, the rightway"
       (interactive)
       (split-window-right)
       (other-window 1))
(defun MCSH/split-below () "Split below, the rightway"
       (interactive)
       (split-window-below)
       (other-window 1))
(global-set-key (kbd "C-x C-3") 'MCSH/split-right)
(global-set-key (kbd "C-x C-2") 'MCSH/split-below)

;; Line
;; (linum-mode 1)

;; git
(use-package magit
  :ensure t
  :config
  (define-key global-map (kbd "C-c g") 'magit)
  )

;; Linum mode
;; (global-linum-mode)

;; Stop the bloody beep
; (global-set-key (kbd "<mouse-6>") 'ignore)
; (global-set-key (kbd "<mouse-7>") 'ignore)
(setq ring-bell-function 'ignore)

;; Neo Tree
(use-package neotree
  :ensure t
  :config
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
  (evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
  (evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "r") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle))

;; Vue
(use-package vue-mode
  :ensure t)
(use-package vue-html-mode
  :ensure t)

;; LSP
(use-package lsp-mode
  :ensure t
  :hook (go-mode . lsp)
  :hook (python-mode . lsp)
  :hook (c++-mode . lsp)
  :hook (c-mode . lsp)
  :hook (dart-mode . lsp)
  :commands lsp
  :config
  (evil-define-key 'normal lsp-mode-map (kbd "g d") 'lsp-find-declaration)
  (setq lsp-dart-sdk-dir "/opt/flutter/bin/cache/dart-sdk")
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq lsp-completion-provider :capf)
  (setq lsp-idle-delay 0.500)
  (setq lsp-log-io nil) ; if set to true can cause a performance hit
  (setq lsp-headerline-breadcrumb-enable nil) ;; We can enable it later on but have to config it first
  )

(use-package helm-lsp
  :ensure t
  :config
  (define-key lsp-mode-map "\C-c\C-h" 'helm-lsp-code-actions)
  (define-key lsp-mode-map "\C-c\C-d" 'helm-lsp-diagnostics))

;; Haskell
(use-package haskell-mode
  :ensure t
  :hook (haskell-mode . interactive-haskell-mode)
  :custom
  (haskell-interactive-popup-errors . nil)
  :config
  (setq haskell-process-type 'stack-ghci)
  (setq haskell-process-path-stack "/home/sajjad/.ghcup/bin/stack")
  ;(setq haskell-process-type 'auto)
  )

(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-server-path "/home/sajjad/.ghcup/bin/haskell-language-server-wrapper")
  :hook (haskell-mode . lsp)
  )

;; ;; setting up haskell wingman

;; (lsp-make-interactive-code-action wingman-fill-hole "refactor.wingman.fillHole")
;; (define-key haskell-mode-map (kbd "C-c n") #'lsp-wingman-fill-hole)

;; (lsp-make-interactive-code-action wingman-case-split "refactor.wingman.caseSplit")
;; (define-key haskell-mode-map (kbd "C-c d") #'lsp-wingman-case-split)

;; (lsp-make-interactive-code-action wingman-refine "refactor.wingman.refine")
;; (define-key haskell-mode-map (kbd "C-c r") #'lsp-wingman-refine)

;; (lsp-make-interactive-code-action wingman-split-func-args "refactor.wingman.spltFuncArgs")
;; (define-key haskell-mode-map (kbd "C-c a") #'lsp-wingman-split-func-args)

;; (lsp-make-interactive-code-action wingman-use-constructor "refactor.wingman.useConstructor")
;; (define-key haskell-mode-map (kbd "C-c c") #'lsp-wingman-use-constructor)

;; (lsp-make-interactive-code-action wingman-homo-split "refactor.wingman.homo")
;; (define-key haskell-mode-map (kbd "C-c x") #'lsp-wingman-homo-split)

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
  :config
  (setq markdown-fontify-code-blocks-natively t) ;; change with C-c C-x C-f
  )

;; Rust
(use-package rust-mode
  :ensure t
  :hook (rust-mode . lsp)
  :config
  ;; (add-to-list 'auto-mode-alist '(".rs" . rust-mode))
  )


;; yasnippet
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

;; No kill please
(defun no-kill (orig-kill &rest args)
  (if (y-or-n-p "Are you sure you want to kill?")
      (apply orig-kill args)
      ))
(advice-add 'kill-emacs :around #'no-kill)

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-globally-ignored-directories (append '("node_modules") projectile-globally-ignored-directories))
  (setq projectile-indexing-method 'hybrid)
  (define-key projectile-mode-map (kbd "C-c C-f") 'projectile-find-file)
  (define-key projectile-mode-map (kbd "C-c f") 'projectile-find-file)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)
  (setq projectile-completion-system 'helm
        projectile-switch-project-action 'helm-projectile))

;; Company

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setf company-idle-delay 0.1))

;; (use-package company-tern
;;   :ensure t
;;   :config
;;   (add-to-list 'company-backends 'company-tern))

;; 2048

(use-package 2048-game
  :ensure t
  :config (defun 2048-g()
            (interactive)
            (2048-game)
            (evil-insert-state)))

;; telegram 

(use-package request
  :ensure t)

(require 'tg)

;; Flutter
(use-package dart-mode
  :ensure t
  :custom
  (dart-format-on-save t))

(use-package flutter
  :after dart-mode
  :ensure t
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload)))

(use-package lsp-dart 
  :ensure t) 

;; GO
(use-package go-mode
  :ensure t
  :config 
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook
            (lambda ()
              (setq tab-width 4)
              (setq indent-tabs-mode nil))))

(use-package go-autocomplete
  :ensure t
  :config
  (defun auto-complete-for-go ()
    (auto-complete-mode 1))
  (add-hook 'go-mode-hook 'auto-complete-for-go))

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(use-package golden-ratio
  :ensure t
  :config
  (golden-ratio-mode 0) ;; disable by default
  (setq golden-ratio-adjust-factor        .6
        golden-ratio-wide-adjust-factor   .8)

(defun fix-ratio (orig &rest args)
      (apply orig args)
      (golden-ratio)
      )
  (advice-add 'evil-window-next :around 'fix-ratio)
  )

(defun max-lv-size-func ()
  "Ensure lv is not larger than a size"
  (message "hoof"))

(golden-ratio-toggle-widescreen)
(add-hook 'lv-window-hook 'max-lv-size-func)


;; replace with capf?
;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (lsp-enable-imenu)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

(use-package flycheck
  :ensure t
  :config (global-flycheck-mode)
  )

(use-package flycheck-rust
  :ensure t
  :config
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
  )

;; Rumi
(require 'rumi)

;; Bison and Lex
(use-package bison-mode
  :ensure t
  :config
  (setq bison-all-electricity-off t)
  (defun bison-indent-new-line () "I don't want this defined")
  (setq bison-mode-map (make-sparse-keymap))
  (define-key bison-mode-map [tab] nil))

;; Makefile
(define-key global-map "\C-cm" 'compile)

;; ASM

;; (add-to-list 'auto-mode-alist '(".ll" . asm-mode))

;; CMAKE
(use-package cmake-mode
  :ensure t)

;; Load current buffers if available
;; (desktop-save-mode 1)

;; lua

(use-package lua-mode
  :ensure t)

;;
;; (use-package org-journal
;;   :ensure t
;;   :custom
;;   (org-journal-dir "~/writing/journal/")
;;   (org-journal-file-format "%Y-%m-%d")
;;   (org-journal-date-format "%e %b %Y (%A)")
;;   )

;; (use-package org-pomodoro
;;   :ensure t
;;   :custom
;;   (org-pomodoro-keep-killed-pomodoro-time t))

;; (use-package org-edna
;;   :ensure t
;;   :config
;;   (org-edna-mode)
;;   )

(use-package glsl-mode
  :ensure t)

;; TS
(use-package typescript-mode
  :ensure t)

(use-package tss
  :ensure t)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; TSX
(use-package web-mode
              :ensure t)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(setq typescript-indent-level 2)

;; EPresent
(use-package epresent
  :ensure t
  :config
  (add-hook 'epresent-start-presentation-hook (lambda () (evil-insert-state)))
  )

;; SLIME
;;(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(use-package slime
  :ensure t
  :config
  (evil-define-key 'normal slime-mode-map (kbd "g d") 'slime-edit-definition)
  (evil-define-key 'normal slime-mode-map (kbd "g t d") 'slime-edit-definition-other-window)
  (evil-define-key 'normal slime-mode-map (kbd "g b") 'slime-pop-find-definition-stack)
  (evil-define-key 'normal slime-mode-map (kbd "g h") 'slime-documentation-lookup)
  )

;; Replace "sbcl" with the path to your implementation
;; (setq inferior-lisp-program "clisp")
(setq inferior-lisp-program "sbcl")

(global-set-key (kbd "C-c C-e") 'slime-eval-last-expression-in-repl)

;; C#
(use-package csharp-mode
  :ensure t)

;; protobuf
(use-package protobuf-mode
  :ensure t)

;; erc
(setq erc-default-server "irc.libera.chat")
(setq erc-autojoin-channels-alist
          '(("irc.libera.chat" "#lisp")))
(setq erc-nick '("MCSH"))

;; Surrond w/ pair
(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-ج") (lambda ()
                              (interactive)
                              (insert-pair nil ?\[ ?\])))

;; cmake
;; enable colors in compilation
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)


;; compilation window auto close
;; Make the compilation window automatically disappear - from enberg on #emacs
(setq auto-hide-compilation t)
;; (setq auto-hide-compilation nil)

(setq compilation-finish-functions
      (lambda (buf str)
        (if (null (string-match ".*exited abnormally.*" str))
            ;;no errors, make the compilation window go away in a few seconds
            (if auto-hide-compilation
            (progn
              (run-at-time
               "1 sec" nil 'quit-windows-on
               (get-buffer-create "*compilation*"))
              (message "No Compilation Errors!"))
            nil))))


(defun toggle-compile-autohide () "toggle auto hiding compile"
       (interactive)
       (setq auto-hide-compilation (not auto-hide-compilation)))

;; undo tree
;; (global-undo-tree-mode)

;; elixir

(use-package elixir-mode
  :ensure t)

(use-package alchemist
  :ensure t)

(use-package smartparens
  :ensure t
  :hook (elixir-mode . smartparens-mode)
  :config
  (defun my-elixir-do-end-close-action (id action context)
    (when (eq action 'insert)
      (newline-and-indent)
      (previous-line)
      (indent-according-to-mode)))

  (sp-with-modes '(elixir-mode)
    (sp-local-pair "do" "end"
                   :when '(("SPC" "RET"))
                   :post-handlers '(:add my-elixir-do-end-close-action)
                   :actions '(insert)))
  )

(add-to-list 'auto-mode-alist '("\\.eex\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.leex\\'" . web-mode))

(setq web-mode-engines-alist
      '(("elixir" . "\\.leex\\'")))

;; agda
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))
(evil-define-key 'normal agda2-mode-map "gd" 'agda2-goto-definition-keyboard)
;; (define-key agda2-mode-map (kbd "C-c C-v") 'agda2-next-goal)
(setq agda2-fontset-name "mononoki")

;; idris

(use-package idris-mode
  :ensure t)

;; envy
; (add-to-list 'auto-mode-alist '("\\.envy\\'" . lisp-mode))
(add-to-list 'auto-coding-alist '("\\.envy" . default-generic-mode))

;; roam
;; (setq org-directory (concat (getenv "HOME") "/src/roam/"))

;; (use-package org-roam
;;   :after org
;;   :ensure t
;;   :init (setq org-roam-v2-ack t)
;;   :custom
;;   (org-roam-directory (file-truename org-directory))
;;   (org-roam-complete-everywhere t)
;;   (org-roam-capture-templates
;;    '(
;;      ("d" "default" plain "%?"
;;       :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U\n") :unnarrowed t :immediate-finish t)
;;      ("b" "book notes" plain (file "~/src/roam/templates/BookNoteTemplate.org")
;;       :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U\n") :unnarrowed t :immediate-finish t)
;;      ("f" "finance" plain (file "~/src/roam/templates/FinanceTemplate.org")
;;       :target (file+head "finance/${slug}.org" "#+title: ${title}\n#+date: %U\n#+filetags: :Finance:draft:\n") :unarrowed t :immediate-finish t )
;;      ("l" "programming language" plain (file "~/src/roam/templates/LanguageTemplate.org")
;;       :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U\n") :unnarrowed t :immediate-finish t)))
;;   :config
;;   (org-roam-setup)
;;   :bind (("C-c n f" . org-roam-node-find)
;;          ("C-c n g" . org-roam-graph)
;;          ("C-c n r" . org-roam-node-random)
;;          ("C-c n c" . org-roam-capture)
;;          ("C-c n J" . org-roam-dailies-goto-today)
;;          (:map org-mode-map
;;                (("C-c n i" . org-roam-node-insert)
;;                 ("C-c n o" . org-id-get-create)
;;                 ("C-c n t" . org-roam-tag-add)
;;                 ("C-c n a" . org-roam-alias-add)
;;                 ("C-c n l" . org-roam-buffer-toggle)
;;                 ("C-c n b" . helm-bibtex)
;;                 ("C-M-i" . completion-at-point))))
;;   :bind-keymap
;;   ("C-c n j" . org-roam-dailies-map))

;; (defadvice org-roam-insert (around put-cursor-after-text activate)
;;   "Make it so that org roam insert cursor goes after the inserted text"
;;   (insert " ")
;;   (save-excursion
;;     (backward-char)
;;     ad-do-it)
;;   (insert " "))

;; (defun mcsh/tag-new-node-as-draft ()
;;   (org-roam-tag-add '("draft")))
;; (add-hook 'org-roam-capture-new-node-hook #'mcsh/tag-new-node-as-draft)

;; (add-to-list 'display-buffer-alist
;;              '("\\*org-roam\\*"
;;                (display-buffer-in-side-window)
;;                (side . right)
;;                (slot . 0)
;;                (window-width . 0.33)
;;                (window-parameters . ((no-other-window . t)
;;                                      (no-delete-other-windows . t)))))

;; (setq org-roam-mode-section-functions
;;       (list #'org-roam-backlinks-section
;;             #'org-roam-reflinks-section
;;             #'org-roam-unlinked-references-section
;;             ))

;; (require 'org-roam-protocol)

;; (setq org-roam-dailies-directory "daily/")

;; (setq org-roam-dailies-capture-templates
;;       '(("d" "default" entry
;;          "* %?"
;;          :target (file+head "%<%Y-%m-%d>.org"
;;                             "#+title: %<%Y-%m-%d>\n"))))

;; (use-package deft
;;   :after org
;;   :ensure t
;;   :bind
;;   ("C-c n d" . deft)
;;   :custom
;;   (deft-recursive t)
;;   (deft-use-filter-string-for-filename t)
;;   (deft-default-extension "org")
;;   (deft-directory org-roam-directory))

;; winner mode (window change mode)
(winner-mode +1)
(define-key winner-mode-map (kbd "<M-left>") #'winner-undo)
(define-key winner-mode-map (kbd "<M-right>") #'winner-redo)


;; org-roam-ui

;; this is an alpha package...

;; (use-package websocket
;;   :ensure t)
;; (use-package simple-httpd
;;   :ensure t)

;; (add-to-list 'load-path "~/.emacs.d/org-roam-ui/")
;; (load-library "org-roam-ui")
;; ;; (use-package org-roam-ui
;; ;;   :ensure t)

;; (setq org-roam-ui-sync-theme t
;;           org-roam-ui-follow t
;;           org-roam-ui-update-on-save t
;;           org-roam-ui-open-on-start t)

;; end of org-roam-ui

;; org-babel
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((ruby . t)
;;    (shell . t)
;;    (python . t)
;;    (dot . t)
;;    (gnuplot . t)
;;    (R . t)))

;; (use-package ess
;;   :ensure t)

;; ;; org-ref (for citations)
;; (use-package org-ref
;;   :ensure t
;;   :config
;;   (setq org-ref-bibliography-notes "~/src/roam/bibnotes.org"
;;         org-ref-default-bibliography '("~/src/bibs/library.bib")
;;         org-ref-pdf-directory "~/src/manitoba/2.ref/")
;;   (setq bibtex-completion-bibliography "~/src/bibs/library.bib"
;;         bibtex-completion-library-path "~/src/manitoba/2.ref"
;;         bibtex-completion-notes-path "~/src/roam/"))


;; (defun mcsh/bibtex-completion-format-citation-org-cite (keys)
;;   "Format org-links using Org mode's own cite syntax."
;;   (format "cite:%s"
;;     (s-join ";"
;;             (--map (format "%s" it) keys))))

;; (use-package helm-bibtex
;;   :ensure t
;;   :config
;;   (setq bibtex-completion-format-citation-functions
;;         '((org-mode . mcsh/bibtex-completion-format-citation-org-cite)
;;           (latex-mode . bibtex-completion-format-citation-cite)
;;           (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
;;           (python-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
;;           (rst-mode . bibtex-completion-format-citation-sphinxcontrib-bibtex)
;;           (default . bibtex-completion-format-citation-default)))
;;   (helm-add-action-to-source "Insert Link" 'helm-bibtex-insert-citation helm-source-bibtex 0)
;;   )

;; (use-package org-roam-bibtex
;;   :ensure t
;;   :config
;;   (org-roam-bibtex-mode 1))

;; csv

(use-package csv-mode
  :ensure t)

;; dashboard

;; (use-package dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook)
;;   (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
;;   (setq dashboard-projects-backend 'projectile)
;;   (setq dashboard-footer-icon "Go forth and change the world!")
;;   (setq dashboard-center-content 0)
;;   (setq dashboard-items '(
;;                           (projects . 5)
;;                           (bookmarks . 5)
;;                           (agenda . 5)
;;                           (recents  . 5)
;;                           ;; (registers . 5)
;;                           ))
;;   (setq dashboard-set-navigator t)
;;   (setq dashboard-show-shortcuts nil)
;;   (setq dashboard-set-footer nil)
;;   (setq dashboard-startup-banner nil)
;;   (setq dashboard-week-agenda nil)
;;   (define-key dashboard-mode-map (kbd "<cr>") 'dashboard-return)
;;   )

;; dot graphviz

(use-package graphviz-dot-mode
  :ensure t)

;; org-evil
(use-package org-evil
  :ensure t)

;; idris-2

(add-to-list 'load-path "~/.emacs.d/idris2-mode/")
(require 'idris2-mode)

(setq idris2-interpreter-path "~/.idris2/bin/idris2")

;; ;;Fixes lag when editing idris code with evil
;; (defun ~/evil-motion-range--wrapper (fn &rest args)
;;   "Like `evil-motion-range', but override field-beginning for performance.
;; See URL `https://github.com/ProofGeneral/PG/issues/427'."
;;   (cl-letf (((symbol-function 'field-beginning)
;;              (lambda (&rest args) 1)))
;;     (apply fn args)))
;; (advice-add #'evil-motion-range :around #'~/evil-motion-range--wrapper)

(use-package exec-path-from-shell
  :ensure t)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(when (daemonp)
  (exec-path-from-shell-initialize))

;; default input method
(setq default-input-method "farsi-isiri-9147")

;; pyenv
(use-package pyvenv
  :ensure t)

;; ;; org refile
;; (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
;; (setq org-outline-path-complete-in-steps nil) ;; so completion shows full paths
;; (setq org-refile-use-outline-path 'file)

;; latex

;; (use-package auctex-latexmk
;;   :ensure t)

;; (load "auctex.el" nil t t)

;; (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)


;; (use-package latex-preview-pane
;;   :ensure t)

;; carbon
(use-package carbon-now-sh
  :ensure t)

;; Sin
(require 'sin)

;; fold

(use-package origami
  :ensure t)

;; ;; tabnine
;; (use-package company-tabnine
;;   :ensure t
;;   :config
;;   (add-to-list 'company-backends #'company-tabnine)
;;   (setq company-idle-delay 0)
;;   (setq company-show-numbers t))

;; copilot
;;(use-package editorconfig
  ;;:ensure t)

; Load copilot.el, modify this path to your local path.
;;(load-file "~/.emacs.d/copilot.el/copilot.el")

;;(add-hook 'prog-mode-hook 'copilot-mode)
;; (customize-set-variable 'copilot-enable-predicates
;;                         '(evil-insert-state-p))

; complete by copilot first, then company-mode
;;(defun my-tab ()
  ;;(interactive)
  ;;(or (copilot-accept-completion)
      ;;(company-indent-or-complete-common nil)))

; modify company-mode behaviors
;;(with-eval-after-load 'company
  ;;; disable inline previews
  ;;(delq 'company-preview-if-just-one-frontend company-frontends)
  ;;; enable tab completion
  ;;(define-key company-mode-map (kbd "C-<tab>") 'my-tab)
  ;;(define-key company-mode-map (kbd "C-TAB") 'my-tab)
  ;;(define-key company-active-map (kbd "C-<tab>") 'my-tab)
  ;;(define-key company-active-map (kbd "C-TAB") 'my-tab))

;;(with-eval-after-load 'copilot
  ;;(evil-define-key 'insert copilot-mode-map
    ;;(kbd "C-<tab>") #'my-tab))

; provide completion when typing
;; (add-hook 'post-command-hook (lambda ()
;;                                (copilot-clear-overlay)
;;                                (when (evil-insert-state-p)
;;                                  (copilot-complete))))
;; )
;; (setup-copilot)

(use-package org-sticky-header
  :ensure t
  :config
  (setq org-sticky-header-full-path 'full)
  (add-hook 'org-mode-hook 'org-sticky-header-mode))


;; Common Lisp Hyper Space

(load "/home/sajjad/quicklisp/clhs-use-local.el" t) ;; C-c C-d h

;; org agenda and windmove fix
;; (require 'org-windmove)

;; org-gcal
;; note: set org-gcal-client-id and org-gcal-client-secret in secrets.el

;; (setq org-gcal-fetch-file-alist
;;       '(("sajjadheydari74@gmail.com" . "~/src/personal/schedule.org")))

(require 'my-secrets)

;; (use-package org-gcal
;;   :ensure t)

;; (require 'org-gcal)

(setq plstore-cache-passphrase-for-symmetric-encryption t)

;; solve org-agenda line wrap error
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (linum-mode -1)))

;; Slime over rpi

(defvar *current-tramp-path* nil)
(defun connect-to-host (path)
  (setq *current-tramp-path* path)
  (setq slime-translate-from-lisp-filename-function
    (lambda (f)
      (concat *current-tramp-path* f)))
  (setq slime-translate-to-lisp-filename-function
    (lambda (f)
      (substring f (length *current-tramp-path*))))
  (slime-connect "192.168.0.164" 4005))

(defun rpi-slime ()
  (interactive)
  (connect-to-host "/ssh:192.168.0.164:"))

(defun rpi-home-dir ()
  (interactive)
  (find-file (concat "/ssh:192.168.0.164:" "/home/sajjad/")))

(defun connect-tornado ()
  (interactive)
  (setq mslime-dirlist '(("/home/sajjad/src/2023/3.torn/" . "/home/ubuntu/tornado/")
                         ("/home/sajjad/common-lisp/clog/" . "/home/ubuntu/quicklisp/dists/quicklisp/software/clog-20230618-git/")
                         ("/home/sajjad/quicklisp/dists/quicklisp/software/lispcord-20200925-git/" . "/home/ubuntu/quicklisp/dists/quicklisp/software/lispcord-20230618-git/")
                         ("/home/sajjad/quicklisp/" . "/home/ubuntu/quicklisp/")
                         ))
    (setq slime-from-lisp-filename-function
          (lambda (f)
            (let ((dirs (car (seq-filter (lambda (x) (string-prefix-p (cdr x) f)) mslime-dirlist))))
              (if dirs
                  (concat (car dirs) (substring f (length (cdr dirs))))
                f))))
    (setq slime-to-lisp-filename-function
          (lambda (f)
            (let ((dirs (car (seq-filter (lambda (x) (string-prefix-p (car x) f)) mslime-dirlist))))
              (if dirs
                  (concat (cdr dirs) (substring f (length (car dirs))))
                f)))))

(connect-tornado)

;; Just follow the shortcut please
(setq vc-follow-symlinks t)

;; line number mode
(global-display-line-numbers-mode)

;; new frame size
(add-hook 'after-make-frame-functions '(lambda (fr) (set-frame-height fr 40) (set-frame-width fr 80)))


;; EOF
