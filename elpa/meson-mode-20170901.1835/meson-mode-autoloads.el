;;; meson-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "meson-mode" "meson-mode.el" (23419 43120 84000
;;;;;;  0))
;;; Generated autoloads from meson-mode.el

(autoload 'meson-mode "meson-mode" "\
Major mode for editing Meson build system files.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("/meson\\(\\.build\\|_options\\.txt\\)\\'" . meson-mode))

(eval-after-load 'compile '(progn (add-to-list 'compilation-error-regexp-alist 'meson) (add-to-list 'compilation-error-regexp-alist-alist '(meson "^Meson encountered an error in file \\(.*\\), line \\([0-9]+\\), column \\([0-9]+\\):" 1 2 3))))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; meson-mode-autoloads.el ends here
