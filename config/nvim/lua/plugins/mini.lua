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
      -- Only create the autocmd to save the session when an actual file is opened (i.e. not an
      -- unnamed scratch buffer that I close without saving).
      -- Sessions are scoped to each git repo by using `Sessions.name`.
      vim.api.nvim_create_autocmd("BufReadPre", {
        callback = function()
          vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
              local name = Sessions.name()
              if name then
                MiniSessions.write(name)
              end
            end,
            pattern = "*",
          })
        end,
      })
    end,
  },
}
