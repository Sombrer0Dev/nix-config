local opts = {
  plugins = {
    jedi_completion = {
      include_params = true,
    },
    jedi_signature_help = { enabled = true },
    autopep8 = { enabled = false },
    flake8 = { enabled = false },
    pycodestyle = {
      enabled = true,
      ignore = { 'E501', 'E231' },
      maxLineLength = 120,
    },
    yapf = { enabled = true },
  },
}

return opts
