local opts = {
  plugins = {
    rope_autoimport = {
      enabled = true,
    },
    jedi_completion = {
      include_params = true,
    },
    jedi_signature_help = { enabled = true },
    autopep8 = { enabled = true },
    flake8 = { enabled = true },
    pycodestyle = {
      enabled = true,
      ignore = { 'E501', 'E231' },
      maxLineLength = 120,
    },
    yapf = { enabled = true },
  },
}

return opts
