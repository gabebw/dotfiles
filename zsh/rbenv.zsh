ruby_version() {
  local version=`rbenv version | sed 's| .*$||'`
  print "%{$fg[magenta]%}${version}%{$reset_color%}"
}

eval "$(rbenv init -)"
