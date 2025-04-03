-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
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
vim.o.undodir = vim.fn.stdpath("config") .. "/undodir"

-- Delete comment character when joining commented lines
vim.opt.formatoptions:append({ j = true })

-- Let mappings and key codes timeout in 100ms (the default is 1 second)
vim.o.ttimeout = true
vim.o.ttimeoutlen = 100

-- Create backups
vim.o.backup = true
vim.o.writebackup = true
vim.o.backupdir = vim.fn.stdpath("config") .. "/backups"
-- setting backupskip to this to allow for 'crontab -e' using vim.
-- thanks to: http://tim.theenchanter.com/2008/07/crontab-temp-file-must-be-ed
if vim.fn.has('unix') then
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
vim.o.textwidth = 80

-- This character is prepended to wrapped lines
vim.o.showbreak = "@"

-- Terminal.app keeps having a notification and "jumping" on the dock from Vim's
-- bells, and this disables terminal Vim's bells.
-- http://vim.wikia.com/wiki/Disable_beeping
vim.o.errorbells = false
vim.o.visualbell = true

-- Autocomplete with dictionary words when spell check is on
vim.opt.complete:append("kspell")
vim.o.spellfile = vim.fn.stdpath("config") .. "/vim-spell-en.utf-8.add"

vim.o.grepprg = "rg --hidden --vimgrep --with-filename --max-columns 200 --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"

-- The wild* settings are for _command_ (like `:color<TAB>`) completion, not for
-- completion of words in files.
vim.o.wildmenu = true -- enable a menu near the Vim command line
vim.o.wildignorecase = true -- ignore case when completing file names and directories
vim.o.wildmode = "list:longest,list:full"
vim.opt.completeopt = { "menu", "menuone", "longest", "preview" }

-- Searching
vim.cmd([[
command! -nargs=+ -complete=file -bar Grep silent! grep! -F <q-args> | copen 10 | redraw!
command! -nargs=+ -complete=file -bar GrepRegex silent! grep! <args> | copen 10 | redraw!
]])

function CharacterUnderCursor()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  return vim.api.nvim_get_current_line():sub(column, column+1)
end

function SearchableWordNearCursor()
  -- <cword> tries a little too hard to find a word.
  -- Given this (cursor at |):
  -- hello | there
  -- Then the <cword> is `there`.
  -- Thus, we use `CharacterUnderCursor` (which is precise) to determine if we're
  -- on a word at all.
  if CharacterUnderCursor():match("^%s$") then
    return ''
  else
    local word_under_cursor = vim.fn.expand('<cword>')
    -- Sometimes the word under the cursor includes punctuation, in which case
    -- '\bWORD!\b' will fail because \b is a word boundary and we have non-word
    -- characters in WORD. So, remove them. This results in a less-precise match
    -- (it'll find WORD as well as WORD!, for example), but is better than getting
    -- zero results.
    return word_under_cursor:gsub('[$!?]', '')
  end
end

function SearchForWordUnderCursor()
  local searchable_word = SearchableWordNearCursor()

  if searchable_word:len() == 0 then
    -- All whitespace or empty, don't search for it because there will be
    -- thousands of (useless) results.
    vim.fn.echo('Not searching for whitespace or empty string')
  else
    local s = "'\\b" .. vim.fn.shellescape(searchable_word) .. "\\b'"
    vim.cmd.GrepRegex(s)
  end
end

vim.keymap.set('n', 'K', SearchForWordUnderCursor, { remap = false })

-- Opens a file with the current working directory already filled in so you have to specify only the filename.
vim.cmd([[
nnoremap <Leader>e :e <C-R>=escape(expand('%:p:h'), ' ') . '/'<CR>
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
nnoremap <leader>q :tabedit '$HOME/.config/fish/config.fish')<CR>
]])

-- PLUGIN OPTIONS
-- Supertab
-- Tell Supertab to start completions at the top of the list, not the bottom.
vim.g.SuperTabDefaultCompletionType = "<c-n>"

-- peekaboo
vim.g.peekaboo_window = "vert bo 50new"

-- FZF
-- This prefixes all FZF-provided commands with 'Fzf' so I can easily find cool
-- FZF commands and not have to remember 'Colors' and 'History/' etc.
vim.g.fzf_command_prefix = "Fzf"
-- Ctrl-M is Enter: open in tabs by default
vim.g.fzf_action = {
	["ctrl-m"] = "tabedit",
	["ctrl-e"] = "edit",
	["ctrl-p"] = "split",
	["ctrl-v"] = "vsplit"
}

vim.cmd([[
command! -bang -nargs=? -complete=dir FilesWithPreview
     \ call fzf#vim#files(<q-args>,
     \   fzf#vim#with_preview(),
     \   <bang>0)

nnoremap <Leader>t :FilesWithPreview<CR>
]])

-- rails.vim
vim.g.rails_projections = {
     ["config/routes.rb"] = { command = "routes" },
     ["app/admin/*.rb"] = {
       command = "admin",
       alternate = "spec/controllers/admin/{singular}_controller_spec.rb",
     },
     ["spec/controllers/admin/*_controller_spec.rb"] = {
       alternate = "app/admin/{plural}.rb",
     },
     ["spec/factories/*.rb"] = { command = "factories" },
     ["spec/factories.rb"] = { command = "factories" },
     ["spec/features/*_spec.rb"] = { command = "feature" },
     ["config/locales/en/*.yml"] = {
       command = "tran",
       template = "en:\n  {underscore|plural}:\n    ",
     },
     ["app/services/*.rb"] = {
       command = "service",
       test = "spec/services/{}_spec.rb"
     },
     ["script/datamigrate/*.rb"] = {
       command = "datamigrate",
       template = "#!/usr/bin/env rails runner\n\n",
     },
     ["app/jobs/*_job.rb"] = {
       command = "job",
       template = "class {camelcase|capitalize|colons}Job < ActiveJob::Job\n  def perform(*)\n  end\nend",
       test = { "spec/jobs/{}_job_spec.rb" }
     },
}

-- fugitive
-- Get a direct link to the current line (with specific commit included!) and
-- copy it to the system clipboard
vim.cmd([[
command! GitLink silent .Gbrowse!
command! GitLinkFile silent 0Gbrowse!

augroup Fugitive
  autocmd!
  " Open the commit hash under the cursor, in GitHub
  autocmd FileType fugitiveblame nnoremap <buffer> <silent> gb :Gbrowse <C-r><C-w><CR>
augroup END
" Prevent Fugitive from raising an error about .git/tags by telling it to
" explicitly check .git/tags
set tags^=./.git/tags
]])

-- vim-trimmer
-- filetypes, check with `:set ft?`
vim.g.trimmer_repeated_lines_blacklist_file_types = { "conf", "python", "eruby.yaml" }
vim.g.trimmer_repeated_lines_blacklist_file_base_names = { "schema.rb", "structure.sql" }

-- vim-tmux-runner
-- Open runner pane to the right, not to the bottom
vim.g.VtrOrientation = "h"
-- Take up this percentage of the screen
vim.g.VtrPercentage = 30
vim.cmd([[
" Attach to a specific pane
nnoremap <leader>va :VtrAttachToPane<CR>
]])

-- Test running
vim.cmd([[
nnoremap <Leader>l :w<CR>:TestNearest<CR>:redraw!<CR>
nnoremap <Leader>a :w<CR>:TestFile<CR>:redraw!<CR>
]])
vim.g["test#strategy"] = "vtr"
vim.g["test#ruby#rspec#options"] = {
      nearest = '--format documentation',
      file = '--format documentation',
}

-- JSX
-- Don't require a .jsx extension
vim.g.jsx_ext_required = 0

-- luochen1990/rainbow
vim.g.rainbow_conf = {
  ctermfgs = {
      "brown",
      "Darkblue",
      "darkgray",
      "darkgreen",
      "darkcyan",
      "darkred",
      "darkmagenta",
      "brown",
      "gray",
      "black",
      "darkmagenta",
      "Darkblue",
      "darkgreen",
      "darkcyan",
      "darkred",
      "red",
  }
}

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
			{ "fugitive", "readonly", "myfilename", "modified" }
		},
		right = {
		  { "filetype" }
    }
	},
	component = {
		readonly = '%{(&filetype!="help" && &readonly) ? "RO" : ""}'
	},
	component_function = {
		fugitive = "v:lua.LightLineGitBranch",
		myfilename = "LightLineFilename"
	},
	component_visible_condition = {
		readonly = '(&filetype!="help" && &readonly)',
		fugitive = '(exists("*FugitiveHead") && ""!=FugitiveHead())'
	},
	tabline = {
		-- Disable the 'X' on the far right
		right = {}
	}
}

function LightLineGitBranch()
  local max = 25
  if vim.fn.exists("*FugitiveHead") == 1 then
    local branch = vim.fn["FugitiveHead"]()
    if branch:len() == 0 then
      return ""
    else
      if branch:len() > max then
        -- Long branch names get truncated
        return branch:sub(0, max-3) .. '...'
      else
        return branch
      end
    end
  else
    return ""
  end
end

vim.cmd([[
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
]])

-- Tabs
-- Softtabs, 2 spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Plugins
vim.cmd([[
call plug#begin(stdpath('config') . '/bundle')
" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" Ruby/Rails
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
" Allow `cir` to change inside ruby block, etc
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-projectionist'
Plug 'janko-m/vim-test'
Plug 'dag/vim-fish'

" tmux
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'

" Syntax
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/applescript.vim'
Plug 'shmup/vim-sql-syntax'
Plug 'tpope/vim-git'
Plug 'cespare/vim-toml'

" Plumbing that makes everything nicer
" Fuzzy-finder
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" Easily comment/uncomment lines in many languages
Plug 'tomtom/tcomment_vim'
" <Tab> indents or triggers autocomplete, smartly
Plug 'ervandew/supertab'
" Git bindings
Plug 'tpope/vim-fugitive'
" The Hub to vim-fugitive's git
Plug 'tpope/vim-rhubarb'
" Auto-add `end` in Ruby, `endfunction` in Vim, etc
Plug 'tpope/vim-endwise'
" When editing deeply/nested/file, auto-create deeply/nested/ dirs
Plug 'duggiefresh/vim-easydir'
" Cool statusbar
Plug 'itchyny/lightline.vim'
" Easily navigate directories
Plug 'tpope/vim-vinegar'
" Make working with shell scripts nicer ("vim-unix")
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
" Make `.` work to repeat plugin actions too
Plug 'tpope/vim-repeat'
" Intelligently reopen files where you left off
Plug 'farmergreg/vim-lastplace'
" Instead of always copying to the system clipboard, use `cp` (plus motions) to
" copy to the system clipboard. `cP` copies the current line. `cv` pastes.
Plug 'christoomey/vim-system-copy'
" `vim README.md:10` opens README.md at the 10th line, rather than saying "No
" such file: README.md:10"
Plug 'xim/file-line'
Plug 'christoomey/vim-sort-motion'
Plug 'flazz/vim-colorschemes'
Plug 'sjl/gundo.vim'
Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags'
" Easily inspect registers exactly when you need them
" https://github.com/junegunn/vim-peekaboo
Plug 'junegunn/vim-peekaboo'

" Text objects
" required for all the vim-textobj-* plugins
Plug 'kana/vim-textobj-user'
" `ae` text object, so `gcae` comments whole file
Plug 'kana/vim-textobj-entire'
" `l` text object for the current line excluding leading whitespace
Plug 'kana/vim-textobj-line'

" Markdown
Plug 'tpope/vim-markdown'
Plug 'nicholaides/words-to-avoid.vim', { 'for': 'markdown' }
" It does more, but I'm mainly using this because it gives me markdown-aware
" `gx` so that `gx` works on [Markdown](links).
Plug 'christoomey/vim-quicklink', { 'for': 'markdown' }
" Make `gx` work on 'gabebw/dotfiles' too
Plug 'gabebw/vim-github-link-opener', { 'branch': 'main' }

call plug#end()
]])

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
  autocmd FileType ruby,eruby,yaml set iskeyword+=!,?
  " Highlight text between two "---"s as a comment.
  " `\_x` means "x regex character class, with newlines allowed"
  autocmd BufNewFile,BufRead,BufWrite *.md,*.markdown,*.html syntax match Comment /\%^---\_.\{-}---$/
  autocmd VimResized * wincmd =

  " rails.vim
  autocmd User Rails nnoremap <Leader>m :Emodel<Space>
  autocmd User Rails nnoremap <Leader>c :Econtroller<Space>
  autocmd User Rails nnoremap <Leader>v :Eview<Space>
  autocmd User Rails nnoremap <Leader>u :Eunittest<Space>

  " Pretend that verymagic is always on
  nnoremap / /\v
  cnoremap %s/ %s/\v
augroup END
]]

-- vim-plug loads all the filetype, syntax and colorscheme files, so turn them on
-- _after_ loading plugins.
vim.cmd([[
  runtime macros/matchit.vim
  filetype plugin indent on
  syntax enable
]])

if vim.g.vscode == 1 then
  vim.cmd([[
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
  ]])
end
