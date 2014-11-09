// vim: filetype=javascript

function findRdioTab(){
  var app = Application("Google Chrome");
  var rdioTab = undefined;

  // Find the tab that has Rdio in it
  for(var i = 0; i < app.windows().length; i++){
    var window = app.windows[i];
    var possibleRdioTabs = window.tabs.whose({ title: { _endsWith: 'Rdio' } })
    if( possibleRdioTabs.length > 0 ){
      rdioTab = possibleRdioTabs.at(0);
      break;
    }
  }
  return rdioTab;
}


var playCurrentPlaylist = "function playCurrentPlaylist(){   $('.PlayButton:visible:first').click(); }";
var selectAndPlayPlaylist = "function selectAndPlayPlaylist(playlistName){   setTimeout(playCurrentPlaylist, 3000);    $(\"a.playlist[title='\" + playlistName + \"']\").click() }";
var defineFunctions = playCurrentPlaylist + selectAndPlayPlaylist;

// The "run" function is automatically run when the file is run, like "main" in
// some other languages.
function run(argv){
  var rdioTab = findRdioTab();
  var playlistName = argv[0];
  rdioTab.execute({javascript: defineFunctions});
  rdioTab.execute({javascript: 'selectAndPlayPlaylist("' + playlistName + '")'})
}
