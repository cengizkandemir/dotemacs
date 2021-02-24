;;; init.el --- n/a

;;; Commentary:
;; n/a

;;; Code:
(require 'package)

(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("GNU ELPA"     . 10)
        ("MELPA"        . 5)
        ("MELPA Stable" . 0)))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; cosmetics ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

(use-package nyan-mode
  :config
  (setq nyan-animate-nyancat t)
  (setq nyan-wavy-trail t)
  (nyan-mode))

(use-package paren
  :config
  (show-paren-mode 1))

(use-package display-line-numbers
  :config
  (global-display-line-numbers-mode))

(setq-default
 whitespace-line-column 80
 whitespace-style '(face lines-tail empty trailing tab-mark))
(add-hook 'prog-mode-hook #'whitespace-mode)

(setq line-number-mode t)
(setq column-number-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; misc ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package restart-emacs)

(desktop-save-mode 1)
(save-place-mode t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)

(global-set-key (kbd "H-p") 'windmove-up)
(global-set-key (kbd "H-n") 'windmove-down)
(global-set-key (kbd "H-b") 'windmove-left)
(global-set-key (kbd "H-f") 'windmove-right)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(auto-save-visited-mode)
(setq scroll-preserve-screen-position t)

(use-package move-text
  :bind
  (("H-M-p" . move-text-up)
   ("H-M-n" . move-text-down)))
;; does not seem to be necessary for ido mode
;;(setq read-file-name-completion-ignore-case t)
;;(setq read-buffer-completion-ignore-case t)

(use-package projectile
  :bind
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1))

(ido-mode 1)
(ido-everywhere 1)
(use-package flx-ido
  :after (ido)
  :config
  (flx-ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(use-package treemacs
  :bind
  ("<f9>" . treemacs))

(use-package treemacs-projectile
  :after (treemacs projectile))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; coding style ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(electric-pair-mode 1)

(use-package cc-mode
  :bind
  (:map c-mode-base-map
        ("\C-m" . c-context-line-break)))

(c-add-style "ck"
             '("stroustrup"
               (indent-tabs-mode . nil)
               (c-offsets-alist . ((template-args-cont ++)
                                   (innamespace . 0)
                                   (stream-op . ++)
                                   (label . +)
                                   (arglist-close . ++)
                                   (arglist-cont-nonempty c-lineup-gcc-asm-reg
                                                          ++)
                                   (arglist-intro . ++)
                                   (substatement-open . 0)
                                   (statement-cont . ++)
                                   (inline-open . 0)))))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-backslash-column 0)

(c-add-style "airties"
             '("stroustrup"
               (indent-tabs-mode . t)
               (c-basic-offset . 8)))

(c-add-style "gorgon"
             '("stroustrup"
               (indent-tabs-mode . nil)
               (c-offsets-alist . ((innamespace . +)))))

(setq-default c-default-style "ck")

(add-hook 'c-mode-hook (lambda () (c-set-style "airties")))

(add-hook 'LaTeX-mode-hook 'flyspell-mode)

(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-source-correlate-start-server t)
  ;;:hook
  ;;(TeX-after-compilation-finished-functions . TeX-revert-document-buffer)
  )

(use-package pdf-tools
  :config (pdf-tools-install))

;; TODO: find a way to move this into :hook of tex/auctex package
(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; vcs ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :commands magit-status
  :bind
  (("C-x g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; intellisense ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package cmake-mode)

(use-package flycheck
  :hook
  (c++-mode . flycheck-mode)
  (c-mode . flycheck-mode)
  (emacs-lisp-mode . flycheck-mode)
  ;;:config
  ;;(setq-default flycheck-disabled-checkers
  ;;              '(emacs-lisp-checkdoc c/c++-clang c/c++-cppcheck c/c++-gcc))
  )

(use-package company
  :hook
  (c++-mode . company-mode)
  (c-mode . company-mode)
  :bind
  (("C-." . company-complete))
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.05))

(use-package lsp-mode
  :hook
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  (lsp-mode . lsp-headerline-breadcrumb-mode)
  :commands
  (lsp lsp-deferred)
  :config
  (setq lsp-enable-indentation nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-diagnostics-provider :flycheck))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

;;(use-package ccls
;;  :hook
;;  ((c-mode c++-mode) . (lambda () (require 'ccls) (lsp)))
;;  :config
;;  (setq ccls-args '("--log-file=/tmp/ccls.log")))

(provide 'init)

;;; init.el ends here
