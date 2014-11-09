function getPlaylistNames(){
  return _.map($('a.playlist'), function(a) { return $(a).prop('title'); })
}
