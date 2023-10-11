local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Bogster'
config.front_end = 'WebGpu'
config.enable_scroll_bar = true

return config
