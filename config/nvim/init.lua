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
  install = { colorscheme = { "habamax" } },
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
    { "pangloss/vim-javascript" },
    { "MaxMEllon/vim-jsx-pretty" },
    { "leafgarland/typescript-vim" },
    { "peitalin/vim-jsx-typescript" },

    -- Ruby/Rails
    {
      "tpope/vim-rails",
      init = function()
        vim.g.rails_projections = {
          ["config/routes.rb"] = { command = "routes" },
          ["app/admin/*.rb"] = {
            command = "admin",
            alternate = "spec/controllers/admin/{singular}_controller_spec.rb",
          },
          ["spec/controllers/admin/*_controller_spec.rb"] = {
            alternate = "app/admin/{plural}.rb",
          },
          ["app/components/*.html.erb"] = {
            alternate = "app/components/{}.rb",
          },
          ["app/components/*.rb"] = {
            alternate = "app/components/{}.html.erb",
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
            test = "spec/services/{}_spec.rb",
          },
          ["script/datamigrate/*.rb"] = {
            command = "datamigrate",
            template = "#!/usr/bin/env rails runner\n\n",
          },
          ["app/jobs/*_job.rb"] = {
            command = "job",
            template = "class {camelcase|capitalize|colons}Job < ActiveJob::Job\n  def perform(*)\n  end\nend",
            test = { "spec/jobs/{}_job_spec.rb" },
          },
        }
      end,
    },
    { "vim-ruby/vim-ruby" },
    -- Allow `cir` to change inside ruby block, etc
    {
      "rhysd/vim-textobj-ruby",
      dependencies = { "kana/vim-textobj-user" },
      init = function()
        -- definitions blocks	(module, class, def): ro
        -- loop blocks (while, for, until): rl
        -- control blocks	(do, begin, if, unless, case): rc
        -- do statement	(do): rd
        -- any block (including above): rr
        vim.g.textobj_ruby_more_mappings = 1
      end,
    },
    { "tpope/vim-rake" },
    { "tpope/vim-projectionist" },
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
    { "airblade/vim-localorie" },

    { "dag/vim-fish" },

    -- tmux
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

    -- Syntax
    { "rust-lang/rust.vim" },
    { "vim-scripts/applescript.vim" },
    { "shmup/vim-sql-syntax" },
    { "tpope/vim-git" },
    { "cespare/vim-toml" },

    -- Plumbing that makes everything nicer
    -- Easily comment/uncomment lines in many languages
    { "tomtom/tcomment_vim" },

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
    -- Cool statusbar
    { "itchyny/lightline.vim" },
    -- Easily navigate directories
    { "tpope/vim-vinegar" },
    -- Make working with shell scripts nicer ("vim-unix")
    { "tpope/vim-eunuch" },
    { "tpope/vim-surround" },
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
    { "flazz/vim-colorschemes" },
    {
      "zootedb0t/citruszest.nvim",
      lazy = false,
      priority = 1000,
    },
    {
      "xolox/vim-easytags",
      dependencies = { "xolox/vim-misc" },
      init = function()
        vim.g.easytags_events = {}
      end,
    },
    {
      "stevearc/conform.nvim",
      -- This will provide type hinting with LuaLS
      ---@module "conform"
      ---@type conform.setupOpts
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          ["eruby.yaml"] = { "prettierd", "prettier", stop_after_first = true },
          ruby = { "standardrb" },
          eruby = { "erb_lint" },
          markdown = { "prettierd", "prettier", stop_after_first = true },
        },
        formatters = {
          erb_lint = {
            stdin = false,
            tmpfile_format = ".conform.$RANDOM.$FILENAME",
            command = "bundle",
            args = { "exec", "erb_lint", "--autocorrect", "$FILENAME" },
          },
          ruff = {
            command = "uvx",
            args = {
              "ruff",
              "format",
              "--force-exclude",
              "--stdin-filename",
              "$FILENAME",
              "-",
            },
          },
        },
        -- If this is set, Conform will run the formatter asynchronously after save.
        -- It will pass the table to conform.format().
        format_after_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
      },
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      keys = {
        {
          "<leader>fo",
          function()
            require("conform").format({ async = true })
          end,
          desc = "Format buffer",
        },
      },
    },

    -- Text objects
    -- `ae` text object, so `gcae` comments whole file
    { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
    -- `l` text object for the current line excluding leading whitespace
    { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" } },

    -- Markdown
    { "tpope/vim-markdown" },
    { "nicholaides/words-to-avoid.vim", ft = "markdown" },
    -- It does more, but I'm mainly using this because it gives me markdown-aware
    -- `gx` so that `gx` works on [Markdown](links).
    { "christoomey/vim-quicklink", ft = "markdown" },
    -- Make `gx` work on 'gabebw/dotfiles' too
    { "gabebw/vim-github-link-opener", branch = "main" },
    { "wesleimp/stylua.nvim" },
    { "vim-language-dept/css-syntax.vim" },

    -- LSP stuff
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("lspconfig").rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              diagnostics = {
                enable = true,
              },
            },
          },
        })

        require("lspconfig").ts_ls.setup({})
        require("lspconfig").ruby_lsp.setup({
          cmd = { "ruby-lsp" },
          init_options = {
            linters = { "standard" },
          },
        })
        require("lspconfig").pylsp.setup({
          cmd = { "uvx", "--from", "python-lsp-server[all]", "pylsp" },
          plugins = {
            ruff = {
              formatEnabled = true,
              executable = "uvx ruff",
            },
          },
        })
        require("lspconfig").lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                -- Tell the language server to recognize the `vim` global
                globals = {
                  "vim",
                },
              },
            },
          },
        })
        require("lspconfig").eslint.setup({
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
            format = true,
            validate = "on",
            packageManager = "yarn",
          },
          root_dir = function(fname)
            -- For some reason, the default `root_dir` function preferentially finds
            -- ~/.eslintrc.js over `<project root>/.eslintrc.json`. It _should_ be searching upward from the current
            -- file, but for some reason is broken, so I reimplemented a working version here.
            local eslint_config_files = {
              ".eslintrc",
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
              "eslint.config.js",
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.ts",
              "eslint.config.mts",
              "eslint.config.cts",
            }

            return vim.fs.dirname(
              vim.fs.find(eslint_config_files, { upward = true, path = vim.fn.fnamemodify(fname, ":p:h") })[1]
            )
          end,
        })
      end,
    },

    {
      "Saghen/blink.cmp",
      version = "1.*",
      opts = {
        keymap = { preset = "super-tab" },
        completion = {
          accept = { auto_brackets = { enabled = false } },
          menu = {
            auto_show = true,
            border = "single",
            draw = {
              columns = {
                { "kind_icon" },
                { "label" },
                { "source_id", gap = 1 },
              },
            },
          },
          -- Show documentation when selecting a completion item
          documentation = {
            auto_show = true,
            treesitter_highlighting = true,
            auto_show_delay_ms = 0,
          },
        },
        sources = {
          providers = {
            -- Defaults to `{ 'buffer' }`, which means "only show buffer if LSP has no results".
            -- When it's blank, we always show buffer completions.
            lsp = { fallbacks = {} },
          },
        },
      },
    },

    { "folke/lazydev.nvim", opts = {} },

    -- Telescope is absolutely magic.
    {
      "nvim-telescope/telescope.nvim",
      -- branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
      },
      config = function()
        local actions = require "telescope.actions"
        require("telescope").setup({
          defaults = {
            mappings = {
              i = {
                ["<C-h>"] = actions.which_key,
                ["<CR>"] = actions.select_default,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
              },
            },
          },
        })
        require("telescope").load_extension "fzf"
      end,
    },
    -- Use (ported version of) FZF for better performance and to support FZF syntax
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "debugloop/telescope-undo.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
      },
      opts = {
        -- don't use `defaults = { }` here, do this in the main telescope spec
        extensions = {
          undo = {
            side_by_side = true,
            layout_strategy = "horizontal",
            layout_config = {
              height = 0.8,
            },
            -- https://github.com/debugloop/telescope-undo.nvim?tab=readme-ov-file#configuration
            -- opts = {
            mappings = {
              -- Wrapping the actions inside a function prevents the error due to telescope-undo being not
              -- yet loaded.
              i = {
                ["<cr>"] = function(bufnr)
                  require("telescope-undo.actions").restore(bufnr)
                end,
              },
            },
          },
        },
      },
      config = function(_, opts)
        -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
        -- configs for us.
        require("telescope").setup(opts)
        require("telescope").load_extension "undo"
      end,
    },
    {
      "AckslD/nvim-neoclip.lua",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("neoclip").setup()
        vim.cmd [[
          autocmd BufEnter * nmap <buffer> " :Telescope neoclip<CR>
          autocmd BufEnter * imap <buffer> <c-x> <Esc>:Telescope neoclip<CR>
        ]]
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      opts = {
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = false, -- Turn into false from true by default
        },
        actions = {
          change_dir = {
            enable = false,
          },
        },
        filters = {
          -- Show gitignored files (defaults to true, meaning DON'T show them.)
          -- This is an annoying default, because it means that sometimes newly created files will just not show up in
          -- the tree.
          git_ignored = false,
        },
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
              modified = false,
              hidden = false,
              diagnostics = false,
              bookmarks = false,
            },
          },
        },
      },
      init = function()
        -- optionally enable 24-bit colour
        vim.opt.termguicolors = true
      end,
    },
    {
      {
        "scalameta/nvim-metals",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "j-hui/fidget.nvim",
        },
        ft = { "scala", "sbt", "java" },
        opts = function()
          local metals_config = require("metals").bare_config()

          -- https://github.com/scalameta/nvim-metals/discussions/39
          -- *READ THIS*
          -- I *highly* recommend setting statusBarProvider to either "off" or "on"
          --
          -- "off" will enable LSP progress notifications by Metals and you'll need
          -- to ensure you have a plugin like fidget.nvim installed to handle them.
          --
          -- "on" will enable the custom Metals status extension and you *have* to have
          -- a have settings to capture this in your statusline or else you'll not see
          -- any messages from metals. There is more info in the help docs about this
          metals_config.init_options.statusBarProvider = "off"

          -- Optimize memory allocation with serverProperties
          metals_config.settings = {
            serverProperties = {
              "-Xmx4G",
              "-Xms100m",
              "-XX:+UseG1GC",
              "-XX:MaxGCPauseMillis=200",
            },
            showImplicitArguments = true,
            excludedPackages = {
              "akka.actor.typed.javadsl",
              "com.github.swagger.akka.javadsl",
            },
            bloopSbtAlreadyInstalled = true, -- Set to true if you use Bloop
            enableSemanticHighlighting = false, -- Disable for better performance
            superMethodLensesEnabled = false, -- Disable additional lenses
            scalafixConfigPath = ".scalafix.conf", -- Only if you use Scalafix
          }

          return metals_config
        end,
        config = function(self, metals_config)
          local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
            pattern = self.ft,
            callback = function()
              -- Show messages from Metals
              vim.opt_global.shortmess:remove "F"
              require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
          })

          -- Automatically organize imports on save
          vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = nvim_metals_group,
            pattern = "*.scala",
            -- Organizing imports will fail with a warning if the current fails to compile.
            -- That's fine, silence the warning, I don't care about organizing imports if the file has errors.
            command = "silent! lua require('metals').organize_imports()",
          })

          -- Add custom commands for Metals
          vim.api.nvim_create_user_command("MetalsRestart", function()
            require("metals").restart_server()
          end, { nargs = 0 })

          vim.api.nvim_create_user_command("MetalsClean", function()
            vim.cmd "!bloop clean" -- Adjust if you use a different build tool
          end, { nargs = 0 })
        end,
      },
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "folke/trouble.nvim",
        opts = {
          modes = {
            top_level_only = {
              mode = "lsp_document_symbols",
              filter = function(items)
                return vim.tbl_filter(function(item)
                  return not item.parent
                  -- allow 2nd-level:
                  -- or not item.parent.parent
                end, items)
              end,
            },
            preview_float = {
              mode = "diagnostics",
              preview = {
                type = "float",
                relative = "editor",
                border = "rounded",
                title = "Preview",
                title_pos = "center",
                position = { 0, -2 },
                size = { width = 0.3, height = 0.3 },
                zindex = 200,
              },
            },
          },
        }, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
          {
            "<leader>xx",
            "<cmd>Trouble preview_float toggle filter.buf=0 focus=true<cr>",
            desc = "Buffer Diagnostics (Trouble)",
          },
          {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Project Diagnostics (Trouble)",
          },
          {
            "<leader>cs",
            "<cmd>Trouble lsp_document_symbols toggle focus=true<cr>",
            desc = "Symbols (Trouble)",
          },
          {
            "<leader>cf",
            function()
              local t = require "trouble"
              ---@diagnostic disable-next-line: missing-fields
              t.toggle({
                mode = "lsp_document_symbols",
                focus = "true",
                -- Available kinds:
                -- "Class"
                -- "Constructor"
                -- "Enum"
                -- "Field"
                -- "Function"
                -- "Interface"
                -- "Method"
                -- "Module"
                -- "Namespace"
                -- "Package"
                -- "Property"
                -- "Struct"
                -- "Trait"
                filter = { kind = { "Function", "Constant" } },
                -- If `size` is < 1, it is treated as a percentage (0.4 = 40%).
                -- Otherwise, it's treated as absolute number of columns.
                win = { position = "left", size = 0.25 },
              })
              if t.is_open "lsp_document_symbols" then
                -- Key bindings: zm to fold [m]ore (show less), zr to fold [r]educe (show more)

                -- Set fold level to 2, by setting to:
                -- 0 ("Document Symbols")
                ---@diagnostic disable-next-line: missing-parameter
                t.fold_close_all()

                -- 3 times:
                -- + 1 (filename)
                -- + 1 (top level)
                -- + 1 (nested level below that)
                for _ = 1, 3 do
                  ---@diagnostic disable-next-line: missing-parameter
                  t.fold_reduce()
                end
              end
            end,
            desc = "Function Symbols (Trouble)",
          },
        },
      },
    },
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
    end, "Go to next warning")
    map("[r", function()
      vim.diagnostic.jump({ count = -1 })
    end, "Go to previous warning")
    map("grD", function()
      vim.diagnostic.open_float()
    end, "Show diagnostic for this line")

    local t = require "telescope.builtin"

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map("gd", t.lsp_definitions, "[G]oto [D]efinition")

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
      t.lsp_workspace_symbols({ ignore_symbols = { "variable", "property" } })
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

  " Pretend that verymagic is always on
  nnoremap / /\v
  cnoremap %s/ %s/\v
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
