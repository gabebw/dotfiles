# Copied from:
# * https://github.com/halostatue/fish-rake/blob/540affd5f953c8f18f61f1dc7fe18e9e9341a33a/
# * https://github.com/halostatue/fish-utils/blob/2ff02c1524a282dfa19f5abd0ebd1b5c055031ba/functions/latest_modified_file.fish

# @halostatue/fish-rake/functions/clean_rake_cache.fish:v1.2.1
function clean_rake_cache --description 'Clean the rake autocomplete cache'
    for file in cache_path /tmp/rake_completion/$USER/*
        rm "$file"
    end
end

# @halostatue/fish-utils/functions/latest_modified_file.fish:v4.0.2
function latest_modified_file --description 'Return the name of the latest modified file'
    argparse --min-args 1 -- $argv
    or return 1

    __max --using 'path mtime' $argv
end

# @halostatue/fish-utils/functions/md5pwd.fish:v4.0.2
function md5pwd --description 'Return an MD5 hash of the current directory path'
    if command --query md5
        md5 -q -s $PWD
    else if command --query gmd5sum md5sum
        set --local md5sum (command --search gmd5sum md5sum)[1]
        printf "%s" $PWD | $md5sum --text - | string split --fields 1 ' '
    end
end

# @halostatue/fish-utils/functions/__max.fish:v4.0.2
function __max --description 'Print the maximum value from the provided list'
    argparse --min-args=1 'u/using=' -- $argv
    or return 1

    set --function result $argv[1]
    set --erase argv[1]

    if set --query _flag_using
        set _flag_using (string split ' ' $_flag_using)
    end

    while set --query argv[1]
        set left $argv[1]
        set right $result

        if set --query _flag_using
            set left ($_flag_using $argv[1])
            set right ($_flag_using $result)
        end

        if test -z $left
            set left 0
        end

        if test -z $right
            set right 0
        end

        if test $left -gt $right
            set result $argv[1]
        end

        set --erase argv[1]
    end

    echo $result
end

# @halostatue/fish-rake/completions/rake.fish:v1.2.1
function _halostatue_fish_rake_cache_completion --description 'Create rake completions'
    set --function cache_path /tmp/rake_completion/$USER
    mkdir -p $cache_path
    set --function cache_file $cache_path/(md5pwd)
    set --function files Rakefile rakefile rakefile.rb Rakefile.rb *.rake **/*.rake
    set --function latest_rake (latest_modified_file $cache_file $files)

    if test $latest_rake != $cache_file
        set --local rake rake
        if test -e bin/rake
            set rake bin/rake
        else if test -f Gemfile
            set rake bundle exec rake
        end

        $rake --silent --tasks --all 2>/dev/null |
            string replace -r --filter '^rake (\S+)\s+# (?:[^#]+# )?(.*)$' '$1\t$2' >$cache_file
    end

    cat $cache_file
end

function _halostatue_fish_rake_complete
    test -f rakefile
    or test -f Rakefile
    or test -f rakefile.rb
    or test -f Rakefile.rb
end

complete -x -c rake -a "(_halostatue_fish_rake_cache_completion)" -n _halostatue_fish_rake_complete

# common completions for rake
complete -c rake -s T -l tasks --description "Display the tasks (matching optional PATTERN) with descriptions, then exit"
complete -c rake -s h -l help --description "Display rake's help message"
complete -c rake -s V -l version --description "Display the program version"
complete -c rake -s v -l verbose --description "Log message to standard output (default)"
complete -c rake -s t -l trace --description "Turn on invoke/execute tracing, enable full backtrace"

# more exotic completions
complete -c rake -s C -l classic-namespace --description "Put Task and FileTask in the top level namespace"
complete -c rake -s D -l describe --description "Describe the tasks (matching optional PATTERN), then exit"
complete -c rake -s n -l dry-run --description "Do a dry run without executing actions"
complete -c rake -s e -l execute -x --description "Execute some Ruby code and exit"
complete -c rake -s p -l execute-print -x --description "Execute some Ruby code, print the result, then exit"
complete -c rake -s E -l execute-continue -x --description "Execute some Ruby code, then continue with normal task processing"
complete -c rake -s I -l libdir -x --description "Include LIBDIR in the search path for required modules"
complete -c rake -s P -l prereqs --description "Display the tasks and dependencies, then exit"
complete -c rake -s q -l quiet --description "Do not log messages to standard output"
complete -c rake -s f -l rakefile --description "Use FILE as the rakefile"
complete -c rake -s R -l rakelibdir -l rakelib -x --description "Auto-import any .rake files in RAKELIBDIR. (default is 'rakelib')"
complete -c rake -s r -l require -x --description "Require MODULE before executing rakefile"
complete -c rake -l rules --description "Trace the rules resolution"
complete -c rake -s N -l no-search -l nosearch --description "Do not search parent directories for the Rakefile"
complete -c rake -s s -l silent --description "Like --quiet, but also suppresses the 'in directory' announcement"
complete -c rake -s g -l system --description "Using system wide (global) rakefiles (usually '~/.rake/*.rake')"
complete -c rake -s G -l no-system -l nosystem --description "Use standard project Rakefile search paths, ignore system wide rakefiles"
