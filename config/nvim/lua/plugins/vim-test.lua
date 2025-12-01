---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "janko-m/vim-test",
    init = function()
      vim.g["test#strategy"] = "vtr"
      vim.g["test#ruby#rspec#options"] = {
        nearest = "--format documentation",
        file = "--format documentation",
      }

      vim.cmd [[
          nnoremap <Leader>l :w<CR>:TestNearest<CR>:redraw!<CR>
          nnoremap <Leader>a :w<CR>:TestFile<CR>:redraw!<CR>
        ]]
    end,
  },
}
