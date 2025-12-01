---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "christoomey/vim-tmux-runner",

    init = function()
      -- Open runner pane to the right, not to the bottom
      vim.g.VtrOrientation = "h"
      -- Take up this percentage of the screen
      vim.g.VtrPercentage = 20
      vim.cmd [[
          " Attach to a specific pane
          nnoremap <leader>va :VtrAttachToPane<CR>
          nnoremap <leader>rr :w<CR>:VtrSendCommandToRunner eval (history search --prefix 'clear;' -n1)<CR>
        ]]
    end,
  },
  { "christoomey/vim-tmux-navigator" },
}
