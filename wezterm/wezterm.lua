-- ~/.config/wezterm/wezterm.lua

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 主题
config.color_scheme = "Tokyo Night Storm"
config.term = "xterm-256color"
enable_wayland= false
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20
config.window_padding = { left = 7, right = 7, top = 10, bottom = 0 }

-- 字体优化
config.font = wezterm.font_with_fallback {
  { family = "Monaco", weight = "Medium"},
  "Menlo"}
config.font_size = 24.0
config.line_height = 1.05
config.freetype_load_flags   = "NO_HINTING"
config.freetype_load_target  = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_render_target = 'Light'
config.freetype_load_target = 'Normal'

-- 快捷键
config.keys = {
  --  全屏切换
  {
    key = 'f',
    mods = 'CTRL|CMD',
    action = wezterm.action.ToggleFullScreen,
  },

  -- 新建标签页
  {
    key = 'n',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'DefaultDomain',
  },
  -- 关闭当前 Pane/Tab
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}
config.native_macos_fullscreen_mode = true

return config
