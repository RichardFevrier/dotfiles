local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.front_end = "WebGpu"

config.window_background_opacity = 0.7

config.enable_scroll_bar = true

config.color_scheme = 'Dracula'
config.colors = {
  scrollbar_thumb = '#f8f8f2'
}

--[[
config.keys = {
  {
    key = 'C',
    mods = 'CTRL',
    action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
  },
  {
    key = 'V',
    mods = 'CTRL',
    action = wezterm.action.PasteFrom 'Clipboard'
  },
  {
    key = 'V',
    mods = 'CTRL',
    action = wezterm.action.PasteFrom 'PrimarySelection'
  },
}
--]]

return config
