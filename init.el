(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'org-journal)

(require 'setup-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(add-to-list 'load-path "~/.emacs.d/elpa/eglot-20221020.1010")
(add-to-list 'load-path "~/.emacs.d/elpa/company-20220110.2248")
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20200604.246")
(require 'eglot) (require 'company) (require 'yasnippet)
(global-company-mode) (yas-global-mode)

(setq lsp-clients-clangd-args
	  '("-j=8"
		"--header-insertion=never"
		"--all-scopes-completion"
		"--background-index"
		"--clang-tidy"
		"--compile-commands-dir=build"
		"--cross-file-rename"
		"--suggest-missing-includes"))

(use-package modern-cpp-font-lock
  :config
  (modern-c++-font-lock-global-mode))

(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(use-package cmake-mode)
(use-package cmake-ide)
(setq cmake-ide-build-pool-use-persistent-naming 1)
(setq cmake-ide-flags-c++ '("-I/usr/include" "-I/usr/local/include" "-I/usr/lib" "-I/usr/local/lib"))
(cmake-ide-setup)

(require 'project-cmake)

(setq astyle-default-args "~/.astylerc")
(use-package astyle
  :ensure t
  :when (executable-find "astyle")
  :hook (c-mode . astyle-on-save-mode))
(use-package astyle
  :ensure t
  :when (executable-find "astyle")
  :hook (c++-mode . astyle-on-save-mode))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

(global-font-lock-mode t)
(add-hook 'c-mode-hook 'display-line-numbers-mode)
(setq linum-format "%3d ")
(global-set-key "\C-xs" 'save-buffer)
(global-set-key "\C-xv" 'quoted-insert)
(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-xf" 'search-forward)
(global-set-key "\C-xc" 'compile)
(global-set-key "\C-xt" 'text-mode);
(global-set-key "\C-xr" 'replace-string);
(global-set-key "\C-xa" 'repeat-complex-command);
(global-set-key "\C-xm" 'manual-entry);
(global-set-key "\C-xw" 'what-line);
(global-set-key "\C-x\C-u" 'shell);
;(global-set-key "\C-x0" 'overwrite-mode);
(global-set-key "\C-x\C-r" 'toggle-read-only);
(global-set-key "\C-t" 'kill-word);
(global-set-key "\C-p" 'previous-line);
(global-set-key "\C-u" 'backward-word);
(global-set-key "\C-o" 'forward-word);
(global-set-key "\C-h" 'backward-delete-char-untabify);
(global-set-key "\C-x\C-m" 'not-modified);
(global-set-key "\C-xj" 'find-journal)

(setq auto-mode-alist (cons '("\\.cxx$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cpp$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hpp$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tex$" . latex-mode) auto-mode-alist))

(require 'font-lock)
(add-hook 'c-mode-hook 'turn-on-font-lock)
(add-hook 'c++-mode-hook 'turn-on-font-lock)

(setq tramp-default-method "ssh")

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\.yml\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\.yaml\'" . yaml-mode))

(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(setq c-default-style "linux"
      c-basic-offset 4)

(use-package which-key
  :init
  (which-key-mode))

(setq backup-directory-alist `(("." . "~/.emacs-saves")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs-auto-saves/" t)))
(setq lock-file-name-transforms `((".*" "~/.emacs-lock-files/" t)))

;; function-args
(require 'function-args)
(fa-config-default)
(custom-set-variables
 '(custom-safe-themes
   '("cf9414f229f6df728eb2a5a9420d760673cca404fee9910551caf9c91cff3bfa" default))
 '(org-agenda-files '("~/journals"))
 '(org-export-backends '(ascii beamer html icalendar latex man md odt texinfo))
 '(package-selected-packages
   '(astyle auto-complete-clang cmake-ide company-c-headers org-bullets ob-rust ob-async helm-etags-plus ccls auto-complete-clang-async lean-mode yasnippet-lean eldoc-cmake eldoc-box company-flx eglot org-pdftools tron-legacy-theme zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu)))
(custom-set-faces
 )

(load-theme 'tron-legacy)
