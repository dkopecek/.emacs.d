;;; cql-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "cql-mode" "cql-mode.el" (0 0 0 0))
;;; Generated autoloads from cql-mode.el

(autoload 'cql-mode "cql-mode" "\
cql major mode

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.cql\\'" . cql-mode))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "cql-mode" '("cql-mode-font-lock-keywords")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cql-mode-autoloads.el ends here
