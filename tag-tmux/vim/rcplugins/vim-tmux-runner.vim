" Open runner pane to the right, not to the bottom
let g:VtrOrientation = "h"

" Take up this percentage of the screen
let g:VtrPercentage = 30

" Attach to a specific pane
nnoremap <leader>va :VtrAttachToPane<CR>

" Zoom into tmux test runner pane. To get back to vim, use <C-a><C-p>
nnoremap <leader>zr :VtrFocusRunner<CR>
