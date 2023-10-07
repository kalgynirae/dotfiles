table.insert(default_access.rules, {
  matches = {
    {
      { "application.name", "=", "Chromium" }
    },
    {
      { "application.process.binary", "=", "electron" }
    },
  },
  default_permissions = "rx",
})
