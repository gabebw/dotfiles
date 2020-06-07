#!/usr/bin/osascript -l JavaScript
// vim: filetype=javascript

/*
 * Usage: things.js PROJECT_NAME
 * Prints out the name and notes for every todo in that project.
 *
 * Prints results in JSON, so to get the name of each item, use `jq`:
 *
 * ./things.js PROJECT | jq .[].notes
 *
 */

// for `$.exit`.
// Yes, this seems like overkill, but I can't figure out how to `exit 1` without
// it.
ObjC.import('stdlib')

// "run" is a magic function name that gets command-line arguments
function run(arguments){
  var projectName = arguments[0];
  if(!projectName){
    console.log("Please provide a project name.");
    $.exit(1)
  }

  var t = Application("Things3");
  var project = t.projects.byName(projectName);
  var results = project.toDos().map(function(t){
    return { name: t.name(), notes: t.notes()};
  });
  return JSON.stringify(results, null, 2);
}
