# Must use print (not echo) for ZSH colors to work
git_branch() {
  if [[ "$vcs_info_msg_0_" != '' ]]
  then
    print "${vcs_info_msg_0_}$(git_dirty)"
  fi
}

# Stolen from pure.zsh:
# https://github.com/sindresorhus/pure/blob/master/pure.zsh
function git_dirty {
  # check if it's dirty
  command git diff --quiet --ignore-submodules HEAD &>/dev/null
  (($? == 1)) && echo ' ✗'
}

##########
# PROMPT #
##########
# MUST wrap $fg in %{...%} or it creates weird errors with commands >1 line
directory="%{$fg[blue]%}%~%{$reset_color%}"
export PROMPT="$directory\$(git_branch) "
export RPROMPT="\$(ruby_version)"
