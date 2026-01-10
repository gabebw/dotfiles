-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

-- Set leader/localleader early because leader is used at the moment mappings
-- are defined. Changing the (local)leader after a mapping is defined has no
-- effect on the mapping.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.o.history = 10000
vim.o.swapfile = false -- http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
vim.o.ruler = true -- show cursor position all the time
vim.o.showcmd = true -- display incomplete commands
vim.o.incsearch = true -- do incremental searching
vim.o.smarttab = true -- insert tabs on the start of a line according to shiftwidth, not tabstop
vim.o.modelines = 2 --  inspect top/bottom 2 lines of the file for a modeline
vim.o.shiftround = true -- When at 3 spaces and I hit >>, go to 4, not 5.
vim.o.colorcolumn = "+0" -- Set to the textwidth

-- Don't ask me if I want to load changed files. The answer is always 'Yes'
vim.o.autoread = true

-- https://github.com/thoughtbot/dotfiles/pull/170
-- Automatically :write before commands such as :next or :!
vim.o.autowrite = true

-- When the type of shell script is /bin/sh, assume a POSIX-compatible shell for
-- syntax highlighting purposes.
-- More on why: https://github.com/thoughtbot/dotfiles/pull/471
vim.g.is_posix = 1

-- Persistent undo
vim.o.undofile = true -- Create FILE.un~ files for persistent undo
vim.o.undodir = vim.fn.stdpath "config" .. "/undodir"

-- Delete comment character when joining commented lines
vim.opt.formatoptions:append({ j = true })

-- Let mappings and key codes timeout in 100ms (the default is 1 second)
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

-- Create backups
vim.o.backup = true
vim.o.writebackup = true
vim.o.backupdir = vim.fn.stdpath "config" .. "/backups"
-- setting backupskip to this to allow for 'crontab -e' using vim.
-- thanks to: http://tim.theenchanter.com/2008/07/crontab-temp-file-must-be-ed
if vim.fn.has "unix" then
  vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
end
vim.opt.listchars = { tab = ">-", trail = "~" }

-- Line numbering
-- With relativenumber and number set, shows relative number but has current
-- number on current line.
vim.o.relativenumber = true
vim.o.number = true
vim.o.numberwidth = 3

vim.opt.backspace = { "indent", "eol", "start" } -- allow backspacing over everything in insert mode
vim.o.autoindent = true
vim.o.copyindent = true -- copy previous indentation on autoindenting
vim.o.showmatch = true -- show matching parenthesis

-- make searches case-sensitive only if they contain upper-case characters
vim.o.ignorecase = true
vim.o.smartcase = true

-- Open below and to the right, the same way you read a page
vim.o.splitbelow = true
vim.o.splitright = true

vim.opt.fileencodings = { "utf-8", "iso-8859-1" }
vim.opt.fileformats = { "unix", "mac", "dos" }
vim.o.textwidth = 100

-- This character is prepended to wrapped lines
vim.o.showbreak = "@"

-- Terminal.app keeps having a notification and "jumping" on the dock from Vim's
-- bells, and this disables terminal Vim's bells.
-- http://vim.wikia.com/wiki/Disable_beeping
vim.o.errorbells = false
vim.o.visualbell = true

-- Autocomplete with dictionary words when spell check is on
vim.opt.complete:append "kspell"
vim.o.spellfile = vim.fn.stdpath "config" .. "/vim-spell-en.utf-8.add"

vim.o.grepprg = "rg --hidden --vimgrep --with-filename --max-columns 200 --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"

-- The wild* settings are for _command_ (like `:color<TAB>`) completion, not for
-- completion of words in files.
vim.o.wildmenu = true -- enable a menu near the Vim command line
vim.o.wildignorecase = true -- ignore case when completing file names and directories
vim.o.wildmode = "list:longest,list:full"
vim.opt.completeopt = { "menu", "menuone", "longest", "preview" }

--- Defines the default border style of floating windows. The default value
--- is empty, which is equivalent to "none". Valid values include:
--- - "bold": Bold line box.
--- - "double": Double-line box.
--- - "none": No border.
--- - "rounded": Like "single", but with rounded corners ("╭" etc.).
--- - "shadow": Drop shadow effect, by blending with the background.
--- - "single": Single-line box.
--- - "solid": Adds padding by a single whitespace cell.
vim.o.winborder = "rounded"

-- When and if I want to fold, use syntax-aware folding.
vim.o.foldmethod = "syntax"
vim.o.foldenable = false

vim.cmd [[
" Close all other windows in this tab, and don't error if this is the only one
nnoremap <Leader>o :silent only<CR>
" move vertically by _visual_ line
nnoremap j gj
nnoremap k gk

" no ex mode
map Q <Nop>

" Automatically reselect text after in- or out-denting in visual mode
xnoremap < <gv
xnoremap > >gv

nnoremap <leader>ev :tabedit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>q :tabedit $HOME/.config/fish/config.fish<CR>
]]

-- PLUGIN OPTIONS

-- fugitive
-- Get a direct link to the current line (with specific commit included!) and
-- copy it to the system clipboard
vim.cmd [[
command! GitLink silent .GBrowse!
command! GitLinkFile silent 0GBrowse!

" Prevent Fugitive from raising an error about .git/tags by telling it to
" explicitly check .git/tags
set tags^=./.git/tags
]]

-- vim-trimmer
-- filetypes, check with `:set ft?`
vim.g.trimmer_repeated_lines_blacklist_file_types = { "conf", "python", "eruby.yaml" }
vim.g.trimmer_repeated_lines_blacklist_file_base_names = { "schema.rb", "structure.sql" }

-- ============================================================================
-- STATUSLINE
-- ===========================================================================
-- always display status line
vim.o.laststatus = 2
-- Don't show `-- INSERT --` below the statusbar since it's in the statusbar
vim.o.showmode = false

-- Tabs
-- Softtabs, 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- The number of milliseconds before "CursorHold" kicks in (default is 4000 = 4 seconds)
vim.o.updatetime = 1000
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Plugins
local ONE_DAY = 60 * 60 * 24
---@diagnostic disable-next-line: missing-fields
require("lazy").setup({
  -- Try to load one of these colorschemes _when starting an installation during startup_
  install = { colorscheme = { "citruszest" } },
  -- automatically check for plugin updates
  checker = { enabled = true, frequency = ONE_DAY * 30 },
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
  spec = {
    { import = "plugins" },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- Helper function for mapping keybindings
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("]r", function()
      vim.diagnostic.jump({ count = 1 })
    end, "Go to next issue (warning or error)")
    map("]R", function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
    end, "Go to next error")
    map("[r", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Go to previous issue (warning or error)")
    map("[R", function()
      vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
    end, "Go to previous error")
    map("grD", function()
      vim.diagnostic.open_float()
    end, "Show diagnostic for this line")

    local snacks = require "snacks"

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map("gd", snacks.picker.lsp_definitions, "[G]oto [D]efinition")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map("gD", snacks.picker.lsp_type_definitions, "Type [D]efinition")

    -- Find references for the word under your cursor.
    map("grr", snacks.picker.lsp_references, "[G]oto [R]eferences")

    map("gh", vim.lsp.buf.hover, "[H]over")

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map("gO", function()
      snacks.picker.lsp_symbols({
        -- Can also specify different ones for each filetype.
        filter = {
          default = {
            -- "Class",
            -- "Constructor",
            -- "Enum",
            -- "Field",
            "Function",
            -- "Interface",
            -- "Method",
            -- "Module",
            -- "Namespace",
            -- "Package",
            -- "Property",
            -- "Struct",
            -- "Trait",
          },
        },
      })
    end, "[D]ocument [S]ymbols")

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map("gws", function()
      snacks.picker.lsp_workspace_symbols({
        filter = {
          default = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            -- "Property",
            "Struct",
            "Trait",
          },
        },
      })
    end, "[W]orkspace [S]ymbols")
  end,
})

vim.cmd [[
augroup vimrc
  " Clear all autocommands in this group so that I don't need to do `autocmd!`
  " for each command. This just clears all of them at once.
  autocmd!

  " on opening the file, clear search-highlighting
  autocmd BufReadCmd set nohlsearch

  " Highlight the current line, only for the buffer with focus
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " Include ! as a word character, so dw will delete all of e.g. gsub!,
  " and not leave the "!"
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=!,?
  " Highlight text between two "---"s as a comment.
  " `\_x` means "x regex character class, with newlines allowed"
  autocmd BufNewFile,BufRead,BufWrite *.md,*.markdown,*.html syntax match Comment /\%^---\_.\{-}---$/

  " Use `#` as the comment character, not `;`
  autocmd BufNewFile,BufRead,BufWrite .npmrc,npmrc setlocal commentstring=#\ %s

  autocmd VimResized * wincmd =
augroup END
]]

-- Restart `prettierd` whenever a prettier file is modified
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("RestartPrettierd", { clear = true }),
  pattern = "*prettier*",
  callback = function()
    vim.fn.system "prettierd restart"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("Lua", { clear = true }),
  pattern = "lua",
  callback = function()
    vim.keymap.set(
      { "v", "x" },
      "g=",
      ":lua<CR>",
      { buffer = true, remap = false, desc = "Source this chunk of Lua code" }
    )
  end,
})

-- Turn filetype, syntax and colorscheme settings on _after_ loading plugins.
vim.cmd [[
  runtime macros/matchit.vim
  filetype plugin indent on
  syntax enable
]]
