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
  -- Cool statusbar
  {
    "itchyny/lightline.vim",
    init = function()
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
    end,
  },
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
}
