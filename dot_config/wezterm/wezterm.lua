local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'dobri_next_a00_black'
config.font = wezterm.font {
  family = 'Fira Code',
  harfbuzz_features = { 'cv02', 'cv29', 'ss01', 'ss03', 'ss05' },
}
config.font_size = 14.5
config.line_height = 1.22
config.front_end = 'WebGpu'
config.enable_scroll_bar = true
config.scrollback_lines = 100000
config.check_for_updates = false

return config
