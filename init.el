(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cmake-mode magit zenburn-theme use-package restart-emacs nyan-mode lsp-ui flycheck fill-column-indicator company-lsp ccls bug-hunter))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; cosmetics ;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package zenburn-theme
  :ensure t)

(use-package nyan-mode
  :ensure t
  :init
  (setq nyan-animate-nyancat t)
  (setq nyan-wavy-trail t)
  :config
  (nyan-mode))

(use-package paren
  :ensure t
  :config
  (show-paren-mode 1))

(use-package display-line-numbers
  :ensure t
  :config
  (global-display-line-numbers-mode))

(setq-default
 whitespace-line-column 80
 whitespace-style '(face lines-tail empty trailing))
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
(use-package restart-emacs
  :ensure t)

(desktop-save-mode 1)
(save-place-mode t)

(global-set-key (kbd "H-p") 'windmove-up)
(global-set-key (kbd "H-n") 'windmove-down)
(global-set-key (kbd "H-b") 'windmove-left)
(global-set-key (kbd "H-f") 'windmove-right)

(which-function-mode)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(auto-save-visited-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; coding style ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(electric-pair-mode 1)

(use-package cc-mode
  :ensure t
  :bind
  (:map c-mode-base-map
	("\C-m" . c-context-line-break)))

(c-add-style "ck"
  '("stroustrup"
    (indent-tabs-mode . nil)
    (c-offsets-alist . ((template-args-cont ++)
			(innamespace . 0)
			(stream-op . ++)
			(arglist-close . ++)
			(arglist-cont-nonempty c-lineup-gcc-asm-reg ++)
			(arglist-intro . ++)
			(substatement-open . 0)
			(statement-cont . ++)
			(inline-open . 0)))))

(setq-default tab-width 8)
(c-add-style "airties"
	     '("stroustrup"
	       (indent-tabs-mode . t)
	       (c-basic-offset . 8)))

(setq-default c-default-style "ck")

(add-hook 'c-mode-hook (lambda ()
			  (c-set-style "airties")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; vcs ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :ensure t
  :commands magit-status
  :bind
  (("C-x g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; intellisense ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package cmake-mode
  :ensure t)

(use-package flycheck
  :ensure t
  :hook
  (c++-mode . flycheck-mode)
  (c-mode . flycheck-mode)
  (emacs-lisp-mode . flycheck-mode)
  :init
  (setq-default flycheck-disabled-checkers
		'(emacs-lisp-checkdoc c/c++-clang c/c++-cppcheck c/c++-gcc)))

(use-package company
  :ensure t
  :hook
  (c++-mode . company-mode)
  (c-mode . company-mode)
  (emacs-lisp-mode . company-mode))

(use-package lsp-mode
  :ensure t
  :commands lsp
  :init
  (setq lsp-enable-indentation nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-prefer-flymake nil))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :after company
  :init
  (push 'company-lsp company-backends))

(use-package ccls
  :ensure t
  :hook
  ((c-mode c++-mode) . (lambda () (require 'ccls) (lsp)))
  :init
  (setq ccls-args '("--log-file=/tmp/ccls.log")))
