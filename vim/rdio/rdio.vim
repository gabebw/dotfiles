function! Rdio()
    let items = fzf#run({'source': 'osascript -l JavaScript output/rdio-list-playlists.scpt'})
    let playlistName = shellescape(items[0])
    call system("osascript -l JavaScript output/rdio-play-specific-playlist.scpt " . playlistName)
endfunction

command! Rdio call Rdio()
