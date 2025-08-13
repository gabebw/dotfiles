return {
  "AckslD/nvim-neoclip.lua",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("neoclip").setup()
    vim.cmd [[
          autocmd BufEnter * nmap <buffer> " :Telescope neoclip<CR>
          autocmd BufEnter * imap <buffer> <c-x> <Esc>:Telescope neoclip<CR>
        ]]
  end,
}
