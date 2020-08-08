" Use old ruby regex engine, which seems to perform better for large files.
setlocal regexpengine=1

" Don't make Vim traverse $PATH to find Ruby
let g:ruby_path = $HOME . "/.rbenv/shims"
