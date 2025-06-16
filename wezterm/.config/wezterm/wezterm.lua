local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================================
-- APARÊNCIA
-- ============================================================================

-- Esquema de cores
config.color_scheme = "tokyonight_moon"

-- Fonte
config.font_size = 11
config.line_height = 1.2
config.font = wezterm.font({
	family = "CaskaydiaCove Nerd Font",
	weight = "Regular",
	harfbuzz_features = {
		"ss01",
		"cv05",
		"calt",
		"ss01",
		"ss02",
		"ss03",
		"ss04",
		"ss05",
		"ss06",
		"zero",
		"onum",
		"ss20",
		"dlig",
	},
})

-- Transparência da janela
-- config.window_background_opacity = 0.6
config.kde_window_background_blur = true

config.window_decorations = "NONE"

-- Padding interno
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- ============================================================================
-- TABS
-- ============================================================================

config.enable_tab_bar = false
-- Mostrar tabs apenas quando há mais de uma
-- config.hide_tab_bar_if_only_one_tab = true

-- Posição da tab bar
-- config.tab_bar_at_bottom = false

-- Estilo da tab bar
-- config.use_fancy_tab_bar = false

-- ============================================================================
-- KEYBINDINGS
-- ============================================================================

config.keys = {
  -- Criar nova tab
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  
  -- Fechar tab atual
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
  
  -- Navegar entre tabs
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  
  -- Recarregar configuração
  {
    key = 'r',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
}

-- ============================================================================
-- CONFIGURAÇÕES GERAIS
-- ============================================================================

-- Histórico de scroll
config.scrollback_lines = 10000

-- Cursor
config.cursor_blink_rate = 800
config.default_cursor_style = 'BlinkingBlock'

-- Som do bell
config.audible_bell = 'Disabled'

-- Verificar atualizações
config.check_for_updates = false

return config
