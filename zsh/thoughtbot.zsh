# Search tiny robots titles

function tr(){
  for num in 1 2 3 4; do
    curl -s http://tinyrobots.thoughtbot.com/sitemap${num}.xml | prettyxml
  done | ag $@ | sed "s/ *<.?loc> *//g"
}
