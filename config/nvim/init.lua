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
vim.o.textwidth = 120

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

-- Searching
local function CharacterUnderCursor()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  return vim.api.nvim_get_current_line():sub(column, column + 1)
end

local function SearchableWordNearCursor()
  -- <cword> tries a little too hard to find a word.
  -- Given this (cursor at |):
  -- hello | there
  -- Then the <cword> is `there`.
  -- Thus, we use `CharacterUnderCursor` (which is precise) to determine if we're
  -- on a word at all.
  if CharacterUnderCursor():match "^%s$" then
    return ""
  else
    local word_under_cursor = vim.fn.expand "<cword>"
    -- Sometimes the word under the cursor includes punctuation, in which case
    -- '\bWORD!\b' will fail because \b is a word boundary and we have non-word
    -- characters in WORD. So, remove them. This results in a less-precise match
    -- (it'll find WORD as well as WORD!, for example), but is better than getting
    -- zero results.
    return word_under_cursor:gsub("[$!?]", "")
  end
end

local function SearchForWordUnderCursor()
  require("telescope.builtin").live_grep({
    default_text = SearchableWordNearCursor(),
  })
end

vim.keymap.set("n", "K", SearchForWordUnderCursor, { remap = false })
vim.keymap.set("n", "<Leader>gg", function()
  require("telescope.builtin").live_grep()
end, { remap = false })
vim.keymap.set("n", "<Leader>go", function()
  require("telescope.builtin").live_grep({
    grep_open_files = true,
    additional_args = { "--fixed-strings" },
  })
end, { remap = false })

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

cnoremap <C-x> <Plug>(TelescopeFuzzyCommandSearch)
]]

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "init.lua" },
  callback = function(event)
    -- "~/.config/nvim"
    local config_dir = vim.fn.stdpath "config"
    local plugins_file = config_dir .. "/lua/plugins/all.lua"
    vim.keymap.set("n", "<Leader>ev", "<cmd>tabedit " .. plugins_file .. "<cr>", {
      buffer = event.buf,
      desc = "Edit plugins from Vim config file",
      -- Yes, overwrite the <Leader>ev that edits $MYVIMRC
      remap = true,
    })
  end,
})

-- PLUGIN OPTIONS
vim.cmd [[
nnoremap <Leader>t :Telescope find_files hidden=true<CR>
nnoremap <Leader>b :Telescope buffers<CR>
augroup mrails
	autocmd!
	autocmd BufEnter {app,spec}/models/*.rb command! -buffer -bar A :exec 'edit '.rails#buffer().alternate()
	autocmd BufEnter {app,spec}/models/*.rb command! -buffer -bar AS :exec 'split '.rails#buffer().alternate()
	autocmd BufEnter {app,spec}/models/*.rb command! -buffer -bar AV :exec 'vsplit '.rails#buffer().alternate()
augroup END
]]

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

vim.g.lightline = {
  colorscheme = "darcula",
  active = {
    left = {
      { "mode", "paste" },
      { "fugitive", "readonly", "myfilename", "modified" },
    },
    right = {
      { "filetype" },
    },
  },
  component = {
    readonly = '%{(&filetype!="help" && &readonly) ? "RO" : ""}',
  },
  component_function = {
    fugitive = "v:lua.LightLineGitBranch",
    myfilename = "LightLineFilename",
  },
  component_visible_condition = {
    readonly = '(&filetype!="help" && &readonly)',
    fugitive = '(exists("*FugitiveHead") && ""!=FugitiveHead())',
  },
  tabline = {
    -- Disable the 'X' on the far right
    right = {},
  },
}

function LightLineGitBranch()
  local max = 25
  if vim.fn.exists "*FugitiveHead" == 1 then
    local branch = vim.fn["FugitiveHead"]()
    if branch:len() == 0 then
      return ""
    else
      if branch:len() > max then
        -- Long branch names get truncated
        return branch:sub(0, max - 3) .. "..."
      else
        return branch
      end
    end
  else
    return ""
  end
end

vim.cmd [[
function! LightLineFilename()
  let unfollowed_symlink_filename = expand('%:p')
  let filename = resolve(unfollowed_symlink_filename)
  let git_root = fnamemodify(FugitiveExtractGitDir(filename), ':h')

  if expand('%:t') == ''
    return '[No Name]'
  elseif git_root != '' && git_root != '.'
    let path = substitute(filename, git_root . '/', '', '')
    " Check if the git root is in another directory, like a dotfile in ~/.vimrc
    " that's really in ~/code/personal/dotfiles/vimrc
    if FugitivePath(filename) !=# unfollowed_symlink_filename
      return path . ' @ ' . git_root
    else
      return path
    endif
  else
    return filename
  endif
endfunction
]]

-- Tabs
-- Softtabs, 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Plugins
ONE_DAY = 60 * 60 * 24
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

vim.keymap.set("n", "<Leader>n", function()
  require("nvim-tree.api").tree.toggle({ path = vim.fn.expand "%:p:h", find_file = true })
end, { remap = false })

vim.keymap.set("n", "<Leader>u", function()
  require("telescope").extensions.undo.undo()
end, { remap = false })

vim.cmd [[
autocmd BufEnter *.yml nmap <buffer> <Leader>y :let @" = substitute(localorie#expand_key(), '^en\.', '', '')<CR>
]]

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
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

    local t = require "telescope.builtin"

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map("gd", t.lsp_definitions, "[G]oto [D]efinition")

    map("gvd", function()
      t.lsp_definitions({ jump_type = "vsplit" })
    end, "[G]oto [D]efinition in vsplit")

    map("gxd", function()
      t.lsp_definitions({ jump_type = "split" })
    end, "[G]oto [D]efinition in split")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map("gD", t.lsp_type_definitions, "Type [D]efinition")

    -- Find references for the word under your cursor.
    map("grr", t.lsp_references, "[G]oto [R]eferences")

    map("gh", vim.lsp.buf.hover, "[H]over")

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map("gO", function()
      t.lsp_document_symbols({ symbols = { "function", "constant" } })
    end, "[D]ocument [S]ymbols")

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map("<leader>ws", function()
      t.lsp_workspace_symbols({
        ignore_symbols = { "variable", "property" },
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
  autocmd VimResized * wincmd =

  " rails.vim
  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>
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

-- Turn filetype, syntax and colorscheme settings on _after_ loading plugins.
vim.cmd [[
  runtime macros/matchit.vim
  filetype plugin indent on
  syntax enable
  colorscheme citruszest
]]

if vim.g.vscode == 1 then
  vim.cmd [[
  " This block is running in VS Code.
  " To tell VS Code to reload this file, reload VS Code with Cmd-r.

  " For tips on how to use it effectively, see the excellent extension
  " documentation:
  " https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim

  " To see what to call a given keybinding (e.g. `editor.action.rename`), see
  " this page:
  " https://vscode-docs.readthedocs.io/en/stable/customization/keybindings/

  nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  nnoremap gR <Cmd>call VSCodeNotify('editor.action.rename')<CR>
  " Don't use VSCode formatting by default - use Vim's built-in version
  " Or, use `gw` if you don't want to unmap
  " https://github.com/vscode-neovim/vscode-neovim/issues/1627#issuecomment-1815441879
  unmap gq

  " Search for word under cursor
  nnoremap K <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': v:lua.SearchableWordNearCursor() })<CR>
  xmap gc  <Plug>VSCodeCommentaryLine
  nmap gc  <Plug>VSCodeCommentaryLine
  omap gc  <Plug>VSCodeCommentaryLine
  nmap gcc <Plug>VSCodeCommentaryLine
  nnoremap S <Cmd>call VSCodeNotify('search.action.focusNextSearchResult')<CR>
  nnoremap % <Cmd>call VSCodeNotify('editor.action.jumpToBracket')
  ]]
end

-- The number of milliseconds before "CursorHold" kicks in (default is 4000 = 4 seconds)
vim.o.updatetime = 1000
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
