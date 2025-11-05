;;; init-package.el --- Setup de pacotes -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuração do sistema de pacotes e use-package

;; Configuração do package.el
(require 'package)
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; Instala use-package se não estiver instalado
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Configuração do use-package
(require 'use-package)
(setq use-package-always-ensure t)  ; Sempre baixa pacotes automaticamente
(setq use-package-verbose t)        ; Mostra o que está carregando

(provide 'init-package)
;;; init-package.el ends here
