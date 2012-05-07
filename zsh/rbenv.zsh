ruby_version() {
  local version=`rbenv version-name`
  print "%{$fg[magenta]%}${version}%{$reset_color%}"
}
