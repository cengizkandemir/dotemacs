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

(use-package paren
  :config
  (show-paren-mode 1))

(use-package display-line-numbers
  :after (cmake-mode) ; needed?
  :hook
  (c++-mode . display-line-numbers-mode)
  (rust-mode . display-line-numbers-mode)
  (c-mode . display-line-numbers-mode)
  (emacs-lisp-mode . display-line-numbers-mode)
  (sh-mode . display-line-numbers-mode)
  (org-mode . display-line-numbers-mode)
  (cmake-mode . display-line-numbers-mode))

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

(use-package exec-path-from-shell)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(global-set-key (kbd "H-p") 'windmove-up)
(global-set-key (kbd "H-n") 'windmove-down)
(global-set-key (kbd "H-b") 'windmove-left)
(global-set-key (kbd "H-f") 'windmove-right)
(global-set-key (kbd "H-y") "\C-a\C- \C-n\M-w\C-y\C-p\C-e")
(global-set-key [f7] 'recompile)

(setq compilation-scroll-output t)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(auto-save-visited-mode)
(setq scroll-preserve-screen-position t)

(use-package move-text
  :bind
  (("H-M-p" . move-text-up)
   ("H-M-n" . move-text-down)))

(use-package ivy
  :ensure swiper
  :bind
  ("C-s" . swiper)
  :config
  (setq ivy-on-del-error-function #'ignore)
  (ivy-mode 1))


(use-package projectile
  :ensure ag
  :bind
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1))

(use-package treemacs
  :bind
  ("<f9>" . treemacs))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package hideshow
  :hook
  (c++-mode . hs-minor-mode)
  (c-mode . hs-minor-mode)
  (rust-mode . hs-minor-mode)
  :bind
  (("H-h" . hs-hide-block)
   ("H-s" . hs-show-block)
   ("H-t" . hs-toggle-hiding)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; coding style ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun enable-electric-pair-local-mode ()
  "Enable electric pair mode locally."
  (electric-pair-local-mode 1))
(add-hook 'c++-mode-hook 'enable-electric-pair-local-mode)
(add-hook 'c++-hook 'enable-electric-pair-local-mode)
(add-hook 'rust-mode-hook 'enable-electric-pair-local-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-electric-pair-local-mode)
(add-hook 'cmake-mode-hook 'enable-electric-pair-local-mode)

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

(use-package rust-mode
  :bind
  (:map rust-mode-map
        ("C-c C-c" . rust-run))
  :config
  (setq rust-format-on-save t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; vcs ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :hook
  (git-commit-mode . (lambda () (setq fill-column 74)))
  :commands magit-status
  :bind
  (("C-x g" . magit-status))
  :config
  (setq git-commit-summary-max-length 50))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; intellisense ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024))

(use-package cmake-mode)

(use-package flycheck
  :hook
  (c++-mode . flycheck-mode)
  (c-mode . flycheck-mode)
  (rust-mode . flycheck-mode)
  (emacs-lisp-mode . flycheck-mode))

(use-package company
  :hook
  (c++-mode . company-mode)
  (c-mode . company-mode)
  (rust-mode . company-mode)
  :bind
  (("C-." . company-complete))
  :config
  (delete 'company-clang company-backends)
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.05))

(use-package lsp-mode
  :hook
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  (rust-mode . lsp-deferred)
  (lsp-mode . lsp-headerline-breadcrumb-mode)
  :commands
  (lsp lsp-deferred)
  :config
  (setq lsp-enable-snippet nil)
  (setq lsp-enable-indentation nil)
  (setq lsp-enable-on-type-formatting nil))

(use-package lsp-ui
  :bind
  ([remap xref-find-references] . lsp-ui-peek-find-references)
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

(use-package treemacs-magit
  :after (treemacs magit))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; debugging ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dap-mode)

(provide 'init)

;;; init.el ends here
