augroup lua_ftplugin
  autocmd!
  autocmd BufWritePre <buffer> lua require("stylua").format()
augroup END
