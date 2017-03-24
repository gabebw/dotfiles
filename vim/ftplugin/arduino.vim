let g:arduino_dir = '/Applications/Arduino.app/Contents/MacOS'
let g:arduino_cmd = g:arduino_dir . '/Arduino'

nnoremap <buffer> <leader>av :ArduinoVerify<CR>
nnoremap <buffer> <leader>au :ArduinoUpload<CR>
