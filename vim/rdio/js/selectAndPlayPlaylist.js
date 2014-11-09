function selectAndPlayPlaylist(playlistName){
  // Wait 3 seconds before hitting play, which should be enough time for the
  // new playlist to load. Make the timeout longer if it's kicking in too soon
  // (for example, if you have a slow connection).
  setTimeout(playCurrentPlaylist, 3000);

  $("a.playlist[title='" + playlistName + "']").click()
}
