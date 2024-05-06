local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'rose-pine'
config.front_end = 'WebGpu'
config.enable_scroll_bar = true
config.scrollback_lines = 100000

return config
