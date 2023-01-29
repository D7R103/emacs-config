(defvar journal-dir
  (expand-file-name"~/journals/"))

(defvar journal
  (format "%sjournal%s.org"
		  journal-dir
		  (format-time-string "%Y%m%d")))

(defvar org-journal-template
  (concat
   "#+TITLE: Journal\n"
   "#+DATE: " (format-time-string "%A %d/%m/%Y\n")
   "* TODAY\n"
   "* NOTES"))

(defun find-journal (days-ago)
  "Find journal from DAYS-AGO"
  (interactive "p")
  (if (not current-prefix-arg)
	  (find-file
	   journal)
	(find-file
	 (concat
	  journal-dir
	  "journal"
	  (format-time-string
	   "%Y%m%d"
	   (seconds-to-time (- (time-to-seconds) (* days-ago 86400))))
	  ".org"))))

(setq org-todo-keywords
	  '((sequence "TODO(t)" "DOING(p)" "|" "DONE(d)" "|" "NOT FINISHED(n)"))
	  org-columns-default-format
	  "%25ITEM %TODO %DEADLINE %EFFORT %TAGS"
	  org-capture-templates
	  '(("t" "Todo" entry (file+headline journal "TODAY")
		 "** TODO %?\n")
		("n" "Note" entry (file+headline journal "NOTES")
		 "** %?\n\n")))

(use-package ob-async)
(use-package ob-rust)
(require 'org-tempo)
(setq org-confirm-babel-evaluate nil
	  org-startup-with-inline-images t
	  org-startup-with-latex-preview t
	  org-export-babel-evaluate nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)
   (calc . t)
   (clojure . t)
   (emacs-lisp . t)
   (js . t)
   (makefile . t)
   (plantuml . t)
   (python . t)
   (rust . t)
   (shell . t)))

(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'markdown-mode-hook 'visual-line-mode)

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(global-set-key "\C-cc" 'org-capture)

(provide 'org-journal)
