" Use vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

if exists('g:vscode')
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
  nnoremap K <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>

  xmap gc  <Plug>VSCodeCommentaryLine
  nmap gc  <Plug>VSCodeCommentaryLine
  omap gc  <Plug>VSCodeCommentaryLine
  nmap gcc <Plug>VSCodeCommentaryLine

  nnoremap S <Cmd>call VSCodeNotify('search.action.focusNextSearchResult')<CR>
  nnoremap % <Cmd>call VSCodeNotify('editor.action.jumpToBracket')
endif
