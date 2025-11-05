;;; init-general.el --- Configurações gerais -*- lexical-binding: t; -*-


;;; Code:

;; =============================================================================
;; MELHORIAS VISUAIS
;; =============================================================================

;; Números de linha
(global-display-line-numbers-mode t)

;; Destaca linha atual
(global-hl-line-mode t)

;; Mostra pares de parênteses
(show-paren-mode t)

;; =============================================================================
;; COMPORTAMENTO DE EDIÇÃO
;; =============================================================================

;; Remove trailing whitespace ao salvar
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Usa espaços ao invés de tabs
(setq-default indent-tabs-mode nil)

;; =============================================================================
;; AUTOCOMPLETAR
;; =============================================================================

(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2)
  (setq company-show-quick-access t)
  (setq company-tooltip-align-annotations t))

;; =============================================================================
;; GERENCIAMENTO DE PROJETOS
;; =============================================================================

(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map))
  :config
  ;; Detecta projetos Rust automaticamente
  (add-to-list 'projectile-project-root-files "Cargo.toml"))

(provide 'init-general)
;;; init-general.el ends here
