(use-package yasnippet-snippets)
(use-package react-snippets)

(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package auto-yasnippet)

(defun company-yasnippet-or-completion ()
  (interactive)
  (let ((yas-fallback-behavior nil))
	(unless (yas-expand)
	  (call-interactively #'company-complete-common))))

(add-hook 'company-mode-hook
		  (lambda () (substitute-key-definition
					  'company-complete-common
					  'company-yasnippet-or-completion
					  company-active-map)))
