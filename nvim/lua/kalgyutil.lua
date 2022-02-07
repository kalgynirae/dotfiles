function change_guifont_size(amount)
  guifont = vim.o.guifont
  new_font = nil
  new_size = nil
  for font, size in string.gmatch(guifont, "(.*):h(%d+)") do
    new_font = font
    new_size = tonumber(size) + amount
  end
  vim.o.guifont = string.format("%s:h%i", new_font, new_size)
end
