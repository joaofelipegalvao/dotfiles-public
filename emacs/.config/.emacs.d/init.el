;;; init.el --- Configuração principal do Emacs -*- lexical-binding: t; -*-

;;; Code:

;; Configuração de pacotes
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-package)

;; Carrega módulos
(require 'init-general)
(require 'init-rust)

;; Custom file (gerado automaticamente pelo Emacs)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
;;; init.el ends here
