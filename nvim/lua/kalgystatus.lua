local mode_hl = {
  ["i"] = "%2*",
  ["ic"] = "%2*",
  ["r"] = "%1*",
  ["t"] = "%5*",
  ["v"] = "%3*",
  ["V"] = "%3*",
  [""] = "%3*",
}
local mode_hide = {
  ["c"] = true,
  ["n"] = true,
  ["nt"] = true,
}
local function mode()
  local m = vim.api.nvim_get_mode().mode
  if mode_hide[m] then
    return "   "
  end
  local hl = mode_hl[m] or ""
  return string.format("%s%%2(%s%%) %%*", hl, string.upper(m))
end

local function diagnostics(buffer)
  if not vim.lsp.buf_is_attached(buffer) then
    return ""
  end
  local errors = vim.diagnostic.get(buffer, {severity = vim.diagnostic.severity.ERROR})
  if #errors > 0 then
    errors_hl = "%6*"
  else
    errors_hl = ""
  end
  local warnings = vim.diagnostic.get(buffer, {severity = vim.diagnostic.severity.WARN})
  if #warnings > 0 then
    warnings_hl = "%7*"
  else
    warnings_hl = ""
  end
  return string.format("%sE:%s%%* %sW:%s%%*", errors_hl, #errors, warnings_hl, #warnings)
end

local function file_info_or_terminal_title(buffer)
  term_title = vim.b[buffer].term_title
  if term_title ~= nil then
    return vim.b[buffer].term_title
  else
    return "%f%q %m%r%h%w"
  end
end

function kalgystatus()
  local buffer = vim.fn.winbufnr(vim.g.statusline_winid)
  return table.concat {
    mode(),
    file_info_or_terminal_title(buffer),
    "%=",
    diagnostics(buffer),
    "  %10(%l,%c%V%)  %P",
  }
end
