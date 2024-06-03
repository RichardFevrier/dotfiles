local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'dobri_next_a00_black'
config.font = wezterm.font('JetBrains Mono', { weight = 'Light' })
config.front_end = 'WebGpu'
config.enable_scroll_bar = true
config.scrollback_lines = 100000

return config
