augroup lua_ftplugin
  autocmd!
  autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })
augroup END
