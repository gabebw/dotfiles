# Completion for Um: https://github.com/sinclairtarget/um

# All subcommands that `um` knows - this is useful for later.
set -l commands list read edit rm topic topics config help

function __um_cmds
  echo -en "list\tList the available pages for the current topic.
read\tRead the given page under the current topic.
edit\tCreate or edit the given page under the current topic.
rm\tRemove the given page.
topic\tGet or set the current topic.
topics\tList all topics.
config\tDisplay configuration environment.
help\tDisplay this help message, or the help message for a sub-command.
"
end

complete -c um -n "__fish_is_nth_token 1" -x -a '(__um_cmds)'

# Disable file completions for the entire command
# because it does not take files anywhere
complete -c um -f

# # Complete read/edit/rm with list of pages
complete -c um -n "__fish_seen_subcommand_from read edit rm" \
    -a "(um list | string replace '\t' '\n')"

complete -c um -n "__fish_seen_subcommand_from topic" \
    -a "(um topics | string replace '\t' '\n')"

complete -c um -n "__fish_seen_subcommand_from config" \
    -a "(um config | rg = | string replace -r '=.*' '' | string trim)"

complete -c um -n "__fish_seen_subcommand_from help" -a "$commands"
