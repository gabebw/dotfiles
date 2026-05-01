---@module "lazy.types"
---@type LazySpec[]
-- Plumbing that makes everything nicer
return {
  -- <Tab> indents or triggers autocomplete, smartly
  {
    "ervandew/supertab",
    init = function()
      -- Tell Supertab to start completions at the top of the list, not the bottom.
      vim.g.SuperTabDefaultCompletionType = "<c-n>"
    end,
  },
  -- Git bindings
  { "tpope/vim-fugitive" },
  -- The Hub to vim-fugitive's git
  { "tpope/vim-rhubarb" },
  -- Auto-add `end` in Ruby, `endfunction` in Vim, etc
  { "tpope/vim-endwise" },
  -- When editing deeply/nested/file, auto-create deeply/nested/ dirs
  { "duggiefresh/vim-easydir" },
  -- Easily navigate directories
  { "tpope/vim-vinegar" },
  -- Make working with shell scripts nicer ("vim-unix")
  { "tpope/vim-eunuch" },
  {
    "tpope/vim-surround",
    config = function()
      -- Reserve `yS` for flash.nvim
      local mappings = {
        "yS",
        "ySs",
        "ySS",
      }
      for _, v in pairs(mappings) do
        vim.keymap.del("n", v)
      end
    end,
  },
  -- Make `.` work to repeat plugin actions too
  { "tpope/vim-repeat" },
  { "tpope/vim-unimpaired" },
  -- Intelligently reopen files where you left off
  { "farmergreg/vim-lastplace" },
  -- Instead of always copying to the system clipboard, use `cp` (plus motions) to
  -- copy to the system clipboard. `cP` copies the current line. `cv` pastes.
  { "christoomey/vim-system-copy" },
  -- `vim README.md:10` opens README.md at the 10th line, rather than saying "No
  -- such file: README.md:10"
  { "xim/file-line" },
  { "christoomey/vim-sort-motion" },
  {
    "xolox/vim-easytags",
    dependencies = { "xolox/vim-misc" },
    init = function()
      vim.g.easytags_events = {}
    end,
  },

  -- Text objects
  -- `ae` text object, so `gcae` comments whole file
  { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
  -- `l` text object for the current line excluding leading whitespace
  { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" } },

  {
    "junegunn/goyo.vim",
    config = function()
      local goyo_group = vim.api.nvim_create_augroup("GoyoGroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        desc = "Hide lualine on goyo enter",
        group = goyo_group,
        pattern = "GoyoEnter",
        callback = function(args)
          require("lualine").hide({})
          require("gitsigns").detach(args.buf)
          -- Prevent GitSigns from re-attaching on :write
          vim.opt_local.eventignore = "BufWritePost"
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        desc = "Set Goyo width to current textwidth",
        group = goyo_group,
        pattern = "*.md",
        callback = function()
          -- Now :Goyo will automatically use the current tw
          vim.g.goyo_width = vim.o.textwidth
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        desc = "Show lualine after goyo exit",
        group = goyo_group,
        pattern = "GoyoLeave",
        callback = function()
          require("lualine").hide({ unhide = true })
        end,
      })
    end,
  },
}
