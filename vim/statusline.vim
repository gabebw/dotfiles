" always display status line
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [
      \             ['mode', 'paste'],
      \             ['emojipocalypse'],
      \             ['fugitive', 'readonly', 'myfilename', 'modified']
      \           ]
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \   'emojipocalypse': '%{emoji#for("sparkles")}',
      \   'readonly': '%{(&filetype!="help" && &readonly) ? emoji#for("lock") : ""}',
      \ },
      \ 'component_function': {
      \   'myfilename': 'LightLineFilename',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ }
\ }

function! LightLineFilename()
  let git_root = fnamemodify(fugitive#extract_git_dir(expand("%:p")), ":h")

  if expand("%:t") == ""
    return "[No Name]"
  elseif git_root != "" && git_root != "."
    return substitute(expand("%:p"), git_root . "/", "", "")
  else
    return expand("%:p")
  endif
endfunction
