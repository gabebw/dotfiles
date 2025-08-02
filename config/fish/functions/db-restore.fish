function db-restore -a db_name filename
  # Only run >1 job if we're running locally.
  # Using >1 job on e.g. Neon leads to an error about a "broken pipe".
  if string match -rq "localhost" $db_name || ! string match -rq 'postgres(ql)?://' $db_name
    # It's restoring to a local DB
    set -f is_local true
  else
    set -f is_local false
  end

  if $is_local
    set -f jobs (getconf _NPROCESSORS_ONLN)
  else
    set -f jobs 1
  end

  if [ (count $argv) -eq 2 ]
    if $is_local
      dropdb --if-exists $db_name
      and createdb $db_name
    end

    pg_restore \
      --verbose \
      --clean \
      --no-acl \
      --no-owner \
      --jobs $jobs \
      --dbname $db_name \
      $filename
  else
    echo "Usage: db-restore DB_NAME FILENAME"
    return 1
  end
end
