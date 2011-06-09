if has("gui_running")
  colorscheme railscasts
  " set background=dark " set to light for light solarized
  "colorscheme solarized

  " FONTS
  if has('win32')
    set gfn=Bitstream\ Vera\ Sans\ Mono\ 12 " Use the Bitstream font
  else
    if has('gui_gtk2') " GTK2 but not GTK1
      try
        set guifont=Inconsolata\ 15
      catch /E596:/ " Invalid font
        set guifont=Menlo\ 12
      endtry
    elseif has('gui_macvim') " MacVim
      try
        set guifont=Inconsolata:h15
      catch /E596:/ " Invalid font
        set guifont=Menlo:h12 " Use the Menlo font
      endtry
    endif
  endif
else
  "colorscheme molokai
endif
