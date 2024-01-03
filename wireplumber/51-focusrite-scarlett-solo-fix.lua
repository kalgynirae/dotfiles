table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "device.name", "matches", "alsa_card.usb-Focusrite_Scarlett_Solo_USB*" },
    },
  },
  apply_properties = {
    ["api.acp.probe-rate"] = 44100,
  },
})
