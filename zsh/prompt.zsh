# %{$terminfo[bold]%}
user_host() { print "%{$terminfo[bold]$fg[cyan]%}%n%{$fg[green]%}|%{$fg[yellow]%}%m"; }

# Must use print (not echo) for ZSH colors to work
git_branch() { print "${vcs_info_msg_0_}$(parse_git_dirty)"; }

# Stolen from oh-my-zsh
parse_git_dirty(){ [[ -n $(git status -s 2> /dev/null) ]] && echo ' ✗'; }

##########
# PROMPT #
##########
# MUST wrap $fg in %{...%} or it creates weird errors with commands >1 line
# Use %f to reset color and use terminal default colors (set in Terminal prefs)
export PROMPT="[\$(user_host)%{$fg[green]%}|\$(ruby_version)\$(git_branch)] %{$fg[blue]%}%~ %{$fg[green]%}$%f "
