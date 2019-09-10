(require 'package)

;; Add Melpa package repository
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)

;; For important compatibility libraries like cl-lib
(when (< emacs-major-version 24)
  (add-to-list 'package-archives (const "gnu" "https://elpa.gnu.org/packages/")))

;; Initialize packages
(package-initialize)

(unless (file-directory-p
         (substitute-in-file-name "$HOME/.emacs.d/elpa/archives/melpa"))
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; bind-key
(use-package bind-key :ensure t)
(require 'bind-key)

;; powerline
(use-package powerline :ensure t
  :config
  (powerline-center-theme))

;; project support
(use-package projectile :ensure t
  :diminish projectile-mode
  :init
  (setq projectile-keymap-prefix (kbd "C-c C-p"))
  :config
  (projectile-mode))

;; git integration
(use-package magit :ensure t)

;; C/C++ tags
(use-package ggtags :ensure t)

;; meson build system mode
(use-package meson-mode :ensure t)

;; asciidoc support
(use-package adoc-mode :ensure t)

;; markdown support
(use-package markdown-mode :ensure t)

;; ido-mode
(use-package ido :ensure t
  :custom
  (ido-enable-flex-mathing t "Show any name that has the chars typed")
  (ido-default-file-method 'selected-window "Use current pane for newly opened file")
  (ido-default-buffer-method 'selected-window "Use current pane for newly switched buffer")
  (max-mini-window-height 0.5 "Big minibuffer height, for ido to show choices vertically")
  :config
  ;; Show choices vertically
  (setf (nth 2 ido-decorations) "\n")
  (ido-mode 1))

;; HELM
(use-package helm :ensure t
  :custom
  (helm-display-buffer-default-height 17)
  (helm-default-display-buffer-functions '(display-buffer-in-side-window))
  :config
  ;; HELM M-x help
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x x") 'helm-mini)
  (helm-mode 1))

;; Python support
(use-package elpy :ensure t
  :custom
  (python-shell-interpreter "python3")
  (elpy-rpc-python-command "python3"))

;; On-the-fly syntax checking
(use-package flycheck
  :ensure t)
(use-package flycheck-clang-analyzer
  :ensure t)

;; LSP
(use-package lsp-mode
  :ensure t
  :hook (prog-mode . lsp)
  :custom
  (lsp-enable-snippet nil))

;; Language Server Protocol (LSP) client
(use-package lsp-ui :ensure t)
(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config (push 'company-lsp company-backends))

;; LSP server (successor of cquery)
(use-package ccls
  :ensure t
  :after projectile
;  :ensure-system-package ccls
  :custom
  (ccls-args nil)
  (ccls-executable (executable-find "ccls"))
  (projectile-project-root-files-top-down-reccuring
   (append '("compile_comands.json" ".ccls")
           projectile-project-root-files-top-down-recurring))
  :config
  (push ".ccls-cache" projectile-globally-ignored-directories)
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  (global-set-key (kbd "C-; <up>") (lambda () (interactive) (ccls-navigate "D")))
  (global-set-key (kbd "C-; <down>") (lambda () (interactive) (ccls-navigate "U")))
  (global-set-key (kbd "C-; <left>") (lambda () (interactive) (ccls-navigate "L")))
  (global-set-key (kbd "C-; <right>") (lambda () (interactive) (ccls-navigate "R")))
  (global-set-key (kbd "C-; m") 'ccls-member-hierarchy)
  (global-set-key (kbd "C-; c") 'ccls-call-hierarchy))

;; multiple cursors
(use-package multiple-cursors :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-*") 'mc/mark-all-like-this)
  (global-unset-key (kbd "M-<down-mouse-1>"))
  (global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click))

;; shell pop
(use-package shell-pop
  :ensure t
  :bind (("C-`" . shell-pop))
  :config
  (setq shell-pop-shell-type (quote ("ansi-term" "*terminal*" (lambda nil (ansi-term shell-pop-term-shell)))))
  (setq shell-pop-term-shell "/usr/bin/fish")
  (setq shell-pop-full-span t)
  ;; need to do this manually or not picked up by `shell-pop'
  (shell-pop--set-shell-type 'shell-pop-shell-type shell-pop-shell-type))

;; Show key binding hints when typing one
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

;; vi-like command and insert mode style editing
;;(use-package xah-fly-keys
;;  :ensure t
;;  :config
;;  (xah-fly-keys-set-layout "qwerty")
;;  (xah-fly-keys 0))

;; Old-style library loading
;(add-to-list 'load-path (substitute-in-file-name "$HOME/.emacs.d/icicles/"))
;(require 'icicles)

(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package cmake-font-lock
  :ensure t
  :after (cmake-mode)
  :hook (cmake-mode . cmake-font-lock-activate))

(use-package cmake-ide
  :ensure t
  :after projectile
  :hook (c++-mode . my/cmake-ide-find-project)
  :preface
  (defun my/cmake-ide-find-project ()
    "Finds the directory of the project for cmake-ide."
    (with-eval-after-load 'projectile
      (setq cmake-ide-project-dir (projectile-project-root))
      (setq cmake-ide-build-dir (concat cmake-ide-project-dir "build")))
    (setq cmake-ide-compile-command
            (concat "cd " cmake-ide-build-dir " && cmake .. && make"))
    (cmake-ide-load-db))

  (defun my/switch-to-compilation-window ()
    "Switches to the *compilation* buffer after compilation."
    (other-window 1))
  :bind ([remap comment-region] . cmake-ide-compile)
  :init (cmake-ide-setup)
  :config (advice-add 'cmake-ide-compile :after #'my/switch-to-compilation-window))

(use-package persp-mode
  :ensure t
  :config
  (setq wg-morph-on nil)
  (setq persp-autokill-buffer-on-remove 'kill-weak)
  :hook
  (after-init-hook
   . (lambda ()
       (persp-mode 1)))
  )

(use-package persp-mode-projectile-bridge
  :ensure t
  :hook
  (persp-mode-projectile-bridge-mode-hook
   . (lambda ()
       (if persp-mode-projectile-bridge-mode
           (persp-mode-projectile-bridge-find-perspectives-for-all-buffers)
         (persp-mode-projectile-bridge-kill-perspectives))))
  (after-init-hook
   . (lambda ()
       (persp-mode-projectile-bridge-mode 1)))
  :after
  (persp-mode)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ccls-args nil nil nil "Customized with use-package ccls")
 '(ccls-executable (substitute-in-file-name "$HOME/.local/bin/ccls") nil nil "Customized with use-package ccls")
 '(cursor-type (quote hbar))
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes
   (quote
    ("9d31039c481c4e9f62198f6b0d35c2853389b5fb9f049710fd2102c63000cd49" default)))
 '(delete-selection-mode nil)
 '(elpy-rpc-python-command "python3")
 '(font-use-system-font t)
 '(frame-title-format (quote ("%f")) t)
 '(fringe-mode 1 nil (fringe))
 '(helm-default-display-buffer-functions (quote (display-buffer-in-side-window)) nil nil "Customized with use-package helm")
 '(helm-display-buffer-default-height 17 nil nil "Customized with use-package helm")
 '(ido-default-buffer-method (quote selected-window))
 '(ido-default-file-method (quote selected-window))
 '(ido-enable-flex-mathing t t)
 '(inhibit-startup-screen t)
 '(lsp-enable-snippet nil nil nil "Customized with use-package lsp-mode")
 '(max-mini-window-height 0.5)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (persp-mode-projectile persp-mode persp-mode-projectile-bridge cql-mode cmake-ide cmake-font-lock cmake-mode protobuf-mode docker dockerfile-mode which-key xah-fly-keys ido-mode flycheck-clang-analyzer flycheck use-package shell-pop powerline multiple-cursors meson-mode magit lsp-ui leuven-theme helm ggtags fzf elpy company-lsp company-irony ccls cargo adoc-mode)))
 '(persp-mode t nil (persp-mode))
 '(persp-mode-projectile-bridge-mode t nil (persp-mode-projectile-bridge))
 '(projectile-project-root-files-top-down-reccuring
   (quote
    ("compile_comands.json" ".ccls" ".svn" "CVS" "Makefile")) t nil "Customized with use-package ccls")
 '(python-shell-interpreter "python3")
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(tool-bar-mode nil)
 '(truncate-lines t)
 '(window-divider-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "lawn green"))))
 '(fringe ((t (:background "#444" :width normal))))
 '(highlight ((t (:background "#233" :weight extra-bold))))
 '(hl-line ((t (:background "#133"))))
 '(linum ((t (:foreground "dim gray" :height 0.8))))
 '(lsp-face-highlight-read ((t (:underline "medium sea green" :weight extra-bold))))
 '(lsp-face-highlight-textual ((t (:underline "sky blue" :weight extra-bold))))
 '(match ((t (:inverse-video t))))
 '(region ((t (:background "#444"))))
 '(window-divider ((t (:foreground "gray10" :width normal))))
 '(window-divider-first-pixel ((t (:foreground "gray20"))))
 '(window-divider-last-pixel ((t (:foreground "black")))))

(set-background-color "#000")
(set-foreground-color "cornsilk2")

;; Set favorite font.
;; Use M-x text-scale-adjust (or C-x C-0) to adjust font size.
(set-frame-font "DejaVu Sans Mono-11")
;; Default frame parameter list
(add-to-list 'default-frame-alist (cons 'font "DejaVu Sans Mono-11"))

;; Custom key bindings
;;(global-set-key (kbd "C-`") 'shell-pop)
(global-set-key [f3] 'eval-region)
(global-set-key [f9] 'menu-bar-mode)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key [f12] 'whitespace-mode)
(global-set-key (kbd "M-<f12>") 'whitespace-cleanup)
(global-set-key (kbd "C-c o") 'find-file-in-project-at-point)

;; Enable line numbers and current line highlighting
(global-linum-mode t)

;; Enable line highlighting
(global-hl-line-mode t)

;; Byte compilation helpers
(defun er-byte-compile-init-dir ()
  "Byte-compile all your dotfiles."
  (interactive)
  (byte-recompile-directory user-emacs-directory 0))

(defun er-remove-elc-on-save ()
  "If you're saving an Emacs Lisp file, likely the .elc is no longer valid."
  (add-hook 'after-save-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))
            nil
            t))

(add-hook 'emacs-lisp-mode-hook 'er-remove-elc-on-save)

;; C/C++ indentation settings
(defconst dnk-cc-mode
  '("cc-mode"
    ;;
    ;; Use setq-default for buffer-local variables to set
    ;; default for all buffers, e.g. tab-width
    ;;
    (setq-default indent-tabs-mode nil)
    (setq-default tab-width 4)
    (setq indent-line-function 'insert-tab)
    (setq c-basic-offset 4)
    (c-offsets-alist . ((innamespace . [0])))
    )
  )

(c-add-style "dnk-cc-mode" dnk-cc-mode)
(setq c-default-style "dnk-cc-mode")

;; Do not use tabs for indentation anywhere
(setq-default indent-tabs-mode nil)
