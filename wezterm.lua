local wezterm = require 'wezterm';
return {
  --enable_tab_bar = false,
  enable_wayland = true,
  exit_behavior = "Close",

  bold_brightens_ansi_colors = false,
  force_reverse_video_cursor = true,
  colors = {
    background = '#232729',
    foreground = '#d1d2d0',
    ansi = {
      '#52595c',
      '#c81f1f',
      '#4e9a06',
      '#c4a800',
      '#3c74c0',
      '#80487f',
      '#069e98',
      '#d1d2d0',
    },
    brights = {
      '#6f6f6b',
      '#ef4529',
      '#8ad834',
      '#f6db4a',
      '#6492f4',
      '#ad70a4',
      '#34e2c2',
      '#f8f8f4',
    },
  },
  font = wezterm.font_with_fallback({
    "Liberation Mono",
    "DejaVu Sans Mono",
    "Font Awesome 5 Pro Solid",
  }),
  window_background_opacity = 0.98,
}
