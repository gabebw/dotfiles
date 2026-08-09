local Sessions = require "sessions"

---@module "lazy.types"
---@type LazySpec[]
return {
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.icons").setup()
      require("mini.sessions").setup()

      -- https://nvim-mini.org/mini.nvim/doc/mini-comment.html
      require("mini.comment").setup()
    end,
    init = function()
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          -- Only save the session when an actual file is opened (i.e. not an
          -- unnamed scratch buffer that I close without saving).
          local is_unnamed_scratch_buffer = #vim.fn.expand "%" == 0
          -- I hit Ctrl-v while editing my command line to open it in Vim
          local is_command_line = vim.fn.expand "%:t" == "command-line.fish"
          if is_unnamed_scratch_buffer or is_command_line then
            return
          end
          MiniSessions.write "Session.vim"
        end,
        pattern = "*",
      })
    end,
  },
}
