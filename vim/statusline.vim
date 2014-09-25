" always display status line
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste'],
      \             ['emojipocalypse'],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ]
      \           ]
      \ },
      \ 'component': {
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \   'emojipocalypse': '%{emoji#for("sparkles")}',
      \   'readonly': '%{&filetype=="help" ? "" : &readonly ? emoji#for("lock") :""}',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ }
\ }
