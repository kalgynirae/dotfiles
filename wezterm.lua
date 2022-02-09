local wezterm = require 'wezterm';
return {
  --enable_tab_bar = false,
  enable_wayland = true,
  exit_behavior = "Close",

  bold_brightens_ansi_colors = false,
  force_reverse_video_cursor = true,
  colors = {
    background = '#1c2022',
    foreground = '#c0c0c0',
    ansi = {
      '#505050',
      '#b44738',
      '#518921',
      '#a79026',
      '#3982ce',
      '#ae4fa3',
      '#008f89',
      '#c0c0c0',
    },
    brights = {
      '#707070',
      '#d2614f',
      '#6ea63f',
      '#c9b047',
      '#5799e7',
      '#c866bb',
      '#00b2ab',
      '#e0e0e0',
    },
  },
  font = wezterm.font_with_fallback({
    "Liberation Mono",
    "DejaVu Sans Mono",
    "Font Awesome 5 Pro Solid",
  }),
}
