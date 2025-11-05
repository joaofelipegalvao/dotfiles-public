;; init-rust.el --- Configuração de Rust -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuração completa para desenvolvimento em Rust

;;; Code:

;; =============================================================================
;; RUST MODE - Básico
;; =============================================================================

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook ((rust-mode . eglot-ensure)
         (rust-mode . cargo-minor-mode))
  :config
  ;; Formata automaticamente ao salvar
  (setq rust-format-on-save t)
  (setq rust-format-on-save-using-rustfmt t))

;; =============================================================================
;; LSP - Language Server Protocol (rust-analyzer)
;; =============================================================================

(use-package eglot
  :ensure t
  :config
  ;; Otimizações de performance
  (setq eglot-autoshutdown t)
  (setq eglot-events-buffer-size 0)
  (setq eglot-sync-connect nil))

;; =============================================================================
;; CARGO - Integração com Cargo
;; =============================================================================

(use-package cargo
  :hook (rust-mode . cargo-minor-mode)
  :config
  ;; Habilita backtrace nos comandos
  (setq cargo-process--enable-rust-backtrace t))

;; =============================================================================
;; TOML MODE - Para editar Cargo.toml
;; =============================================================================

(use-package toml-mode
  :mode "\\.toml\\'")

(provide 'init-rust)
;;; init-rust.el ends here
