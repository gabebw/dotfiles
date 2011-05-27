" **** TABS ****
" Note that ~/.vim/after/ftplugin changes some of these settings
" http://vim.wikia.com/wiki/Indenting_source_code#Setup
" No tabs: set expandtab, set shiftwidth=softtabstop, don't change tabstop
" Pure tabs: set noexpandtab, set tabstop=shiftwidth, don't touch softtabstop
" Tabs+spaces: set noexpandtab, set softtabstop=shiftwidth, don't touch tabstop
"
" http://vim.wikia.com/wiki/Indenting_source_code#Explanation_of_the_options
" tabstop = how many columns a TAB counts for
" shiftwidth = what happens when you press <</>>/==
" softtabstop = number of spaces inserted when TAB is pressed
" expandtab = if expandtab is set, then <TAB> inserts softtabstop amount of
" space characters. Otherwise, the amount of spaces inserted is minimized by
" using TAB characters
" Currently ruby style (tabs = 2 spaces)
set expandtab
" set tabstop=4
set softtabstop=2
set shiftwidth=2
