# Must use print (not echo) for ZSH colors to work
git_branch() { print "${vcs_info_msg_0_}$(parse_git_dirty)"; }

# Stolen from oh-my-zsh
parse_git_dirty(){ [[ -n $(git status -s 2> /dev/null) ]] && echo ' ✗'; }

##########
# PROMPT #
##########
# MUST wrap $fg in %{...%} or it creates weird errors with commands >1 line
directory="%{$fg[blue]%}%~%{$reset_color%}"
export PROMPT="$directory\$(git_branch) "
export RPROMPT="\$(ruby_version)"
